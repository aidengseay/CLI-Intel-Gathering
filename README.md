# CLI-Intel-Gathering

## Overview
Gather intelligence by looking through an enemy's computer learning the basics on how to use the command line interface.

---

## Player Setup

Welcome to the Command Line CTF! You will log into a simulated enemy computer and gather flags using basic command line skills.

#### Login Info

* **Usernames:** `user1`, `user2`, … `user10`
* **Password for all users:** `cyberctx`
* **Port:** `2222`
* **Host IP:** (provided by admin, e.g. `192.168.1.244`)

#### How to Connect

##### Windows (PowerShell)

1. Open **PowerShell**.
2. Run:

   ```powershell
   ssh -p 2222 user1@<host-ip>
   ```

   Replace `user1` with your assigned username, and `<host-ip>` with the IP the admin gives you.

If SSH isn’t available, download and use **PuTTY**:

* Host: `<host-ip>`
* Port: `2222`
* Connection type: SSH

##### macOS / Linux

1. Open **Terminal**.
2. Run:

   ```bash
   ssh -p 2222 user1@<host-ip>
   ```

   Replace `user1` with your assigned username.

#### Once Connected

* You will land in your home directory.
* Inside you will find a folder called **`ctx/`**.
* Explore using common commands (`ls`, `cd`, etc.).
* Some flags may be hidden in files, directories, or even running processes.

#### Your Goal

Collect as many flags (up to 10) as you can by exploring the system. Each flag looks like:

```bash
flag{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}
```

---

## Admin Setup

### Steps

1. Make sure Docker is [installed](https://www.docker.com/get-started/) and running
    - Linux: `systemctl status docker`
    - macOS/Windows: check Docker Desktop is running

2. Build the image on the command line.

    ```bash
    docker build -t cmd-line-ctx:latest .
    ```

3. Run the container on the command line.

- Linux:

  ```bash
  docker run -d \
    --name cmd-line-ctx \
    -p 2222:22 \
    -e CTX_PASSWORD=cyberctx \
    -e FILE_PERMS=600 \
    -v "$PWD/users.txt":/etc/ctx/users.txt:ro \
    -v "$PWD/ctx":/seed/ctx:ro \
    cmd-line-ctx:latest
  ```

- Windows for file path `C:\Users\Cyber\Documents\ctx-ctf\`:

    ```bash
    docker run -d `
      --name cmd-line-ctx `
      -p 2222:22 `
      -e CTX_PASSWORD=cyberctx `
      -e FILE_PERMS=600 `
      -v C:/Users/Cyber/Documents/ctx-ctf/users.txt:/etc/ctx/users.txt:ro `
      -v C:/Users/Cyber/Documents/ctx-ctf/ctx:/seed/ctx:ro `
      cmd-line-ctx:latest
    ```

- Mac for file path `/Users/Cyber/ctx-ctf/`:

  ```bash
  docker run -d \
    --name cmd-line-ctx \
    -p 2222:22 \
    -e CTX_PASSWORD=cyberctx \
    -e FILE_PERMS=600 \
    -v /Users/Cyber/ctx-ctf/users.txt:/etc/ctx/users.txt:ro \
    -v /Users/Cyber/ctx-ctf/ctx:/seed/ctx:ro \
    cmd-line-ctx:latest
  ```

4. Check logs

    ```bash
    docker logs -f cmd-line-ctx
    ```

    - You should see “[ctx] deploying challenges…” and per-user messages.

5. Ensure port 2222 is open

    - Linux: `sudo firewall-cmd --add-port=2222/tcp --permanent && sudo firewall-cmd --reload`
    - macOS/Windows: Docker Desktop handles port forwarding automatically.

6. Players connect

    - Find the docker host IP (Linux: `ip addr`, macOS: `ifconfig en0`, Windows: `ipconfig`).
    - There are a total of 10 user accounts `user1` - `user10` to connect to.

    ```bash
    ssh -p 2222 user1@<host-ip>
    # password: cyberctx
    ```

7. Users explore

    - Users can navigate to `~/ctx/`, run commands, and discover flags. Executables will be runnable but not readable.

8. Reset challenges (without restarting the container)

    ```bash
    docker exec cmd-line-ctx /usr/local/bin/deploy_ctx.sh
    ```

9. Remove the container (go to step 3 to rerun the container)

    ```bash
    docker rm -f cmd-line-ctx
    ```