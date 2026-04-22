{
  "Version": "1.104.X",
  "Auth": {
    "Status": "Verified",
    "LobbyEntry": "Force",
    "GuestReset": true
  },
  "TargetSystem": {
    "LockMode": "Crosshair_Magnet",
    "TargetBone": "Head_Point",
    "Priority": "Closest_To_Crosshair",
    "CrosshairSettings": {
      "AutoLock": true,
      "StickyAim": true,
      "SmoothLock": 0.05,
      "Radius": 150
    }
  },
  "Offsets": {
    "Aimbot": {
      "Function": "Memory_Hook",
      "HeadAddress": "0x1C92A1",
      "CrosshairAddress": "0x2D3E4F",
      "Value": "0x2000B1",
      "AutoSwitch": true,
      "NoWall": true
    },
    "Protection": {
      "AntiCheat": "0x3A2B1C",
      "RiskHub": "null",
      "ShieldStatus": "Active"
    }
  },
  "Global": {
    "AutoEntry": true,
    "FixCrash": true
  }
}
