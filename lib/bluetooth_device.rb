class BluetoothDevice
  attr_accessor :mac, :name
  
  INFO_REGEX = /\s+Icon: input-gaming/

  def initialize(mac = nil, name = nil, paired = false)
    @mac = mac
    @name = name
    @paired = paired
  end

  def controller?
    `bluetoothctl info #{mac}`
      .split("\n")
      .map do |line|
        match = INFO_REGEX.match(line)
        next unless match

        match
      end
      .select do |line|
        line
      end
      .any?
  end

  def pair
    `bluetoothctl remove #{mac}` if @paired
    puts `bluetoothctl pair #{mac}`
    `bluetoothctl trust #{mac}`
  end

  def connect
    `bluetoothctl connect #{mac}`
  end
end
