---
title: "Disable Sony noise-cancellation on Linux"
date: 2022-04-07T23:44:17+02:00
tags: ["WH-1000XM3", "1000XM3", "noise cancellation", "Sony", "Linux", "NC"]
---

I really like my Sony 1000XM3 headphones. They are super comfortable to wear and pack away compactly when I'm travelling.

I have always hated one feature though: the headphones always start with noise-cancelling (NC) enabled. This default setting irritates me because it means I have to charge my headphones more often. In addition, I've also had ear fatigue when I use NC for too long. [0]

Sony provides no way to change this default (they would rather add gamification to their mobile app). After a late evening session with lots of tea for company, I finally figured out a setup to disable NC that works on Linux. It uses a combination of a Python script, udev and systemd to send a magic payload over bluetooth right after the headset is connected.


## Step 1: Setup the Python script

The magic payload is sent using a Python script, using the [pybluez](https://github.com/pybluez/pybluez) module. There's an issue though: newer versions of Python do not work with the old release of `pybluez` on PyPI. I ended up installing the Python package from Github:

```bash
mkdir /home/gagan/projects/disable-nc-sony/
cd /home/gagan/projects/disable-nc-sony/
mkvirtualenv disable-nc-sony
pip install git+https://github.com/pybluez/pybluez
```

Next, create the Python script (`disable-nc-sony.py`) to send the payload. Change the

- [shebang](https://en.wikipedia.org/wiki/Shebang_\(Unix\)), point it to the correct Python executable
- the MAC address for the bluetooth headset.


```python
#!/home/gagan/.virtualenvs/disable-nc-sony/bin/python
"""Toggle noise cancellation on Sony 1000xm3 headphones"""

import sys
import bluetooth

addr = "AA:AA:AA:AA:AA:AA"  # Change me

# Values pulled from this project
# https://github.com/Plutoberth/SonyHeadphonesClient
data = bytearray([62, 12, 0, 0, 0, 0, 8, 104, 2, 0, 1, 0, 1, 0, 255, 127, 60])  # disable NC payload
# data = bytearray([62, 12, 1, 0, 0, 0, 8, 104, 2, 17, 1, 2, 1, 0, 0, 148, 60])  # enable NC payload

uuid = "96CC203E-5068-46ad-B32D-E316F5E069BA"
#print("Searching for service on {}...".format(addr))

service_matches = bluetooth.find_service(uuid=uuid, address=addr)

if len(service_matches) == 0:
    print("Couldn't find the service.")
    sys.exit(0)

first_match = service_matches[0]
port, name, host = first_match["port"], first_match["name"], first_match["host"]

# print('Connecting to "{}" on {}'.format(name, host))

sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
sock.connect((host, port))
sock.send(data)
sock.close()
```

Make sure the make this script executable (this is important in the following steps):

```bash
chmod +x disable-nc-sony.py
```

If things were done correctly, running this script will disable NC on a connected headset.

## Step 2: Setup systemd service

The next step is to trigger this script automatically when the headset is connected. This is where I ran into trouble. Normally, udev is sufficient to trigger commands. This didn't work for me which I later pinned down to the sandbox udev runs in, and the sandbox blocks network communication. The solution is to trigger a systemd service from udev, which is not restricted.

Create a file `/etc/systemd/system/sony-bluetooth-nc.service`

```
[Service]
Type=oneshot
ExecStart=/home/gagan/projects/disable-nc-sony/disable-nc-sony.py
```

## Step 3: Setup udev rule


Create a file `/etc/udev/rules.d/90-sony-bluetooth-headphones.rules`

```
ACTION=="add", SUBSYSTEM=="input",ATTRS{id/vendor}=="054c",ATTRS{id/product}=="0cd3",TAG+="systemd", ENV{SYSTEMD_WANTS}+="sony-bluetooth-nc.service"
```

Run `sudo systemctl daemon-reload` and `sudo udevadm control --reload` to reload configuration.

That's it. When I connect my headphones, NC is disabled right away within a couple of seconds.

### Debugging

Some useful commands for debugging:

- Listen and monitor devices, useful for configuring udev rules `udevadm monitor --property`
- Set udev to debug logging mode `sudo udevadm control --log-priority=debug` (Use `journalctl -f` to view logs).
- Print device params (device path is from udevadm monitor) `udevadm info --attribute-walk --path=PATH`
- systemctl service status `sudo systemctl status sony-bluetooth-nc`

[0] From my limited online research, there are no long term effects of using headphones with active NC for long periods. But I had some and they went away when I stopped using NC.
