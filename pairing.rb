require "require_all"
require_rel "lib"

bluetoothctl_device_regex = /Device\s+(?<mac>([0-9A-F]{2}[:]){5}([0-9A-F]{2}))\s+.*/
hcitool_device_regex = /\s*(?<mac>([0-9A-F]{2}:){5}[0-9A-F]{2})\s+(?<name>.*)/
bluetoothctl_paired_device_regex = /Device\s+(?<mac>([0-9A-F]{2}[:]){5}([0-9A-F]{2}))\s+.*/

while true
  pause = !ProcessHelper.is_emulation_station_running? || ProcessHelper.is_emulator_running
  puts "Waiting for emulator to stop" if pause
  while pause
    sleep 10
  end

  puts "Retrieve info of nearby devices..."
  `timeout 10s bluetoothctl scan on`

  registered_device_macs = `bluetoothctl devices`
    .scan(bluetoothctl_device_regex)
    .flatten

  paired_device_macs = `bluetoothctl paired-devices`
    .scan(bluetoothctl_paired_device_regex).flatten

  puts "Scan for devices in pairing mode..."
  gamepads_in_pairing_mode = `hcitool scan`.split("\n")
    .map do |line|
      match = hcitool_device_regex.match(line)
      next unless match
      next unless registered_device_macs.include? match[:mac]

      paired = paired_device_macs.include? match[:mac]

      BluetoothDevice.new(mac = match[:mac], name = match[:name], paired = paired)
    end
    .select do |device|
      device && device.controller?
    end

  puts "No unpaired gamepads found" if gamepads_in_pairing_mode.none?

  gamepads_in_pairing_mode.each do |gamepad|
    puts "Trying to pair with #{gamepad.name}"
    gamepad.pair
    gamepad.connect
  end

  sleep 10
end
