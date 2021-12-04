require "require_all"
require_rel "lib"

device_regex = /Device\s+(?<mac>([0-9A-F]{2}[:]){5}([0-9A-F]{2}))\s+(?<name>.*)/
paired_mac_regex = /Device\s+(?<mac>([0-9A-F]{2}[:]){5}([0-9A-F]{2}))\s+.*/

while true
  while !ProcessHelper.is_emulation_station_running? || ProcessHelper.is_emulator_running
    sleep 10
  end

  puts "Scanning..."

  `timeout 10s bluetoothctl scan on`

  output_devices = `bluetoothctl devices`
  paired_device_macs = `bluetoothctl paired-devices`
    .scan(paired_mac_regex).flatten

  unpaired_bluetooth_gamepads = output_devices.split("\n")
    .map do |line|
      match = device_regex.match(line)
      next unless match
      next if paired_device_macs.include? match[:mac]

      BluetoothDevice.new(mac = match[:mac], name = match[:name])
    end
    .select do |device|
      device && device.controller?
    end

    puts "No unpaired gamepads found" if unpaired_bluetooth_gamepads.none?

    unpaired_bluetooth_gamepads.each do |gamepad|
      puts "Trying to pair with #{gamepad.name}"
      gamepad.pair
      gamepad.connect
    end

  sleep 10
end
