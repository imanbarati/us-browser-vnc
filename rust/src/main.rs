use std::env;
use std::fs;
use std::path::PathBuf;
use std::process::Command;

fn root() -> PathBuf {
    env::var("USVNC_ROOT").map(PathBuf::from).unwrap_or_else(|_| env::current_dir().unwrap_or_else(|_| PathBuf::from(".")))
}

fn run(command: &str, args: &[&str]) -> bool {
    println!("+ {} {}", command, args.join(" "));
    match Command::new(command).args(args).current_dir(root()).status() {
        Ok(status) => status.success(),
        Err(error) => {
            eprintln!("failed to run {}: {}", command, error);
            false
        }
    }
}

#[cfg(unix)]
fn random_password() -> String {
    use std::io::Read;
    let mut bytes = [0u8; 18];
    if let Ok(mut file) = fs::File::open("/dev/urandom") {
        if file.read_exact(&mut bytes).is_ok() {
            return bytes.iter().map(|b| format!("{:02x}", b)).collect();
        }
    }
    format!("usvnc-{}", std::process::id())
}

#[cfg(windows)]
fn random_password() -> String {
    match Command::new("powershell")
        .args(["-NoProfile", "-Command", "[guid]::NewGuid().ToString('N')"])
        .output()
    {
        Ok(output) => String::from_utf8_lossy(&output.stdout).trim().to_string(),
        Err(_) => format!("usvnc-{}", std::process::id()),
    }
}

fn open_url(url: &str) {
    let (command, args): (&str, Vec<&str>) = match env::consts::OS {
        "windows" => ("cmd", vec!["/c", "start", "", url]),
        "macos" => ("open", vec![url]),
        _ => ("xdg-open", vec![url]),
    };
    if let Err(error) = Command::new(command).args(args).status() {
        eprintln!("Could not open browser automatically: {}. Open this URL yourself: {}", error, url);
    } else {
        println!("Opened {}", url);
    }
}

fn init_env() {
    let path = root().join(".env");
    if path.exists() {
        println!(".env already exists; leaving it unchanged.");
        return;
    }
    let password = random_password();
    let content = format!("DOMAIN=localhost\nVNC_PASSWORD={}\nTZ=UTC\n", password);
    if let Err(error) = fs::write(&path, content) {
        eprintln!("Could not write .env: {}", error);
        return;
    }
    println!("Created .env with a generated VNC password (shown once): {}", password);
    println!("Change DOMAIN to your domain before exposing it publicly.");
}

fn doctor() {
    println!("OS: {}", env::consts::OS);
    println!("Arch: {}", env::consts::ARCH);
    for tool in ["docker", "bash", "aws", "oci", "git"] {
        let found = Command::new(if cfg!(windows) { "where" } else { "which" })
            .arg(tool).output().map(|o| o.status.success()).unwrap_or(false);
        println!("{:<8} {}", tool, if found { "found" } else { "missing" });
    }
    let env_path = root().join(".env");
    println!(".env: {}", if env_path.exists() { "present" } else { "missing (run `usvnc init`)" });
    println!("Note: no cloud account automation or credential storage is included.");
}

fn guide(provider: &str) {
    let (url, steps): (&str, &[&str]) = match provider {
        "aws" => (
            "https://signin.aws.amazon.com/signup",
            &[
                "Create ONE AWS account with your own email and payment method.",
                "Enable MFA and set a billing alarm before launching anything.",
                "Install/configure the AWS CLI yourself: aws configure.",
                "Then run providers/aws/deploy.sh from this repository.",
            ],
        ),
        "oracle" => (
            "https://www.oracle.com/cloud/free/",
            &[
                "Create ONE Oracle Cloud account; choose a US region.",
                "Generate OCI API keys in the console and configure ~/.oci/config.",
                "Collect COMPARTMENT_ID, SUBNET_ID, AVAILABILITY_DOMAIN and IMAGE_ID.",
                "Then run providers/oracle/deploy.sh.",
            ],
        ),
        "github" => (
            "https://github.com/codespaces",
            &[
                "Use your existing GitHub account; enable Codespaces if needed.",
                "Open this repository as a codespace from GitHub.",
                "Port 6080 is forwarded automatically; read the password from the terminal.",
                "Codespaces is temporary and for development/testing only.",
            ],
        ),
        "cloudflare" => (
            "https://dash.cloudflare.com/sign-up",
            &[
                "Optional: add a domain you control to Cloudflare.",
                "Use Cloudflare Access free tier to protect the noVNC hostname.",
                "No Cloudflare secret is needed for the local stack.",
            ],
        ),
        _ => {
            eprintln!("Unknown provider. Use: aws | oracle | github | cloudflare");
            return;
        }
    };
    println!("Account guide: {}", provider);
    for (index, step) in steps.iter().enumerate() {
        println!("  {}. {}", index + 1, step);
    }
    println!("Do not share passwords or verification codes with the agent. Use your browser vault if needed.");
    open_url(url);
}

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();
    let command = args.first().map(String::as_str).unwrap_or("help");
    match command {
        "doctor" => doctor(),
        "init" => init_env(),
        "up" => { run("docker", &["compose", "up", "-d", "--build"]); }
        "down" => { run("docker", &["compose", "down"]); }
        "status" => { run("docker", &["compose", "ps"]); }
        "guide" => {
            let provider = args.get(1).map(String::as_str).unwrap_or("aws");
            guide(provider);
        }
        "providers" => {
            println!("aws       - t2.micro, US region, free tier (time-limited)");
            println!("oracle    - Always Free ARM, US region, best persistent option");
            println!("github    - Codespaces, temporary, dev/test only");
            println!("cloudflare - Access/domain protection only; no VNC service");
        }
        _ => {
            println!("usvnc - US-region noVNC browser CLI");
            println!("Commands: doctor | init | up | down | status | providers | guide <aws|oracle|github|cloudflare>");
            println!("Boundaries: no account creation, no credential storage, no ban guarantees.");
        }
    }
}
