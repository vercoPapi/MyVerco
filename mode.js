const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Konfigurasi Header agar bisa diakses dari aplikasi/executor (CORS)
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

// Database Offset & Settingan Aimbot (Server Risk Hub Null)
// Target: Head Lock, No Window, Smart Target Switching
const freeFireOffsets = {
    game_version: "1.104.X", // Sesuaikan versi FF saat ini
    status: "Active",
    settings: {
        aimbot_head: {
            offset_name: "AimLock_Head",
            hex_value: "0x1A2B3C", // Contoh Offset Memory Address
            lock_type: "Bone_Head",
            smooth_factor: 0.5,
            no_wallbang: true,
            auto_switch: true, // Bisa digeser ke player lain
            fov_range: 180.0
        },
        risk_bypass: {
            hub_status: "null",
            server_side_check: false,
            anti_ban_v2: true
        }
    },
    system: {
        hide_window: true,
        render_mode: "overlay_only",
        refresh_rate: "60ms"
    }
};

// Endpoint Utama untuk dipanggil oleh Client via URL
app.get('/api/v1/offsets/freefire', (req, res) => {
    try {
        res.status(200).json(freeFireOffsets);
    } catch (error) {
        res.status(500).json({ message: "Server Error", error: error.message });
    }
});

// Endpoint untuk mengecek koneksi server
app.get('/', (req, res) => {
    res.send("Server Risk Hub Null is Running.");
});

app.listen(PORT, () => {
    console.log(`Server aktif di port: ${PORT}`);
    console.log(`URL API: http://localhost:${PORT}/api/v1/offsets/freefire`);
});
