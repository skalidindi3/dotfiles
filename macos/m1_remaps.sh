# https://developer.apple.com/library/archive/technotes/tn2450/_index.html
keyboard_map() {
  hidutil property --get "UserKeyMapping"
}
keyboard_remap() {
  hidutil property --set '{
    "UserKeyMapping":[
      {"HIDKeyboardModifierMappingSrc":0xC000000CF,"HIDKeyboardModifierMappingDst":0xFF00000009},
      {"HIDKeyboardModifierMappingSrc":0x10000009B,"HIDKeyboardModifierMappingDst":0xFF00000008},
  ]}'
  # map Do Not Disturb (F6) to F11, to allow F11 automator script running via (F6)
  #   {"HIDKeyboardModifierMappingSrc":0x10000009B,"HIDKeyboardModifierMappingDst":0x700000044},
}
keyboard_unmap() {
  hidutil property --set '{"UserKeyMapping":[]}'
}
