VRChat / Steam Frame / xrizer

Steam launch options:
XRIZER_CUSTOM_BINDINGS_DIR=/home/reina/frame-finger/xrizer/bindings/vrchat %command%

Use the experimental xrizer branch experiment/frame-rs-main with Frame support.
This variable selects bindings; it does not select or rebuild the OpenVR runtime.
Restart VRChat after changing the JSON. If this checkout moves, update the path.

framecontroller.json is the filename expected by xrizer (no underscore).
The controller_type inside the file is frame_controller (with underscore).
The game files and actions.json do not need modification.

Based on the locally installed VRChat Meta Touch default bindings:
- Left thumbstick: movement; right thumbstick: turning.
- Triggers: interaction / UI confirmation; grips: grab / drag.
- Right A: jump; right B: Udon menu, following the Touch defaults.
- Left D-pad down: microphone (Touch X).
- Left D-pad right: Udon menu (Touch Y).
- Left View / right Menu: Quick Menu.
- Both hand skeletons, raw poses and haptics are included.
- Action Menu, one-hand and drone bindings are retained from the Touch defaults.

Known xrizer limits: the inherited chords are currently ignored by its binding
parser. Safe-mode and drone chord shortcuts are therefore not verified.
Finger tracking still requires valid controller skeleton data from WiVRn and
Avatars Use Finger Tracking enabled in VRChat. This binding has not been tested
on a real Steam Frame.
