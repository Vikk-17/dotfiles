## Instruction 

```bash
# rules for automatically detect montiors and adjuct both of them.
cp 95-monitor-hotplug.rules /etc/udev/rules.d/
chmod 777 95-monitor-hotplug.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```
