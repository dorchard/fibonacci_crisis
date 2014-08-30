defonce :out do
  OSC::Client.new("10.0.0.8", 8113)
end

define :osc do |m, v|
  out.send(OSC::Message.new(m, v))
end


codes = "

mode = 1

define :dotransp do
  use_transpose 5
end

define :melody3 do
 dotransp()
 if mode == 0 then 
 use_synth_defaults amp: 0.5
 with_synth :tri do
  play :C3
  sleep 1
  play :A3
  sleep 1
  play :G3
  sleep 1
  play :A3
  sleep 1
  end
  else
  sleep 1
  end
end

define :melody2 do
 dotransp()
 with_fx :reverb, rate: 0.9, amp: 0.0 do
  2.times do |x|
  sleep (0.25/(x+1))
  play :G3
  sleep (0.25/(x+1))
  play :A4
  sleep (0.5/(x+1))
  play :C4
  end
  end
  sleep 0.5
end

define :melody do
  dotransp()
  with_fx :compressor do
  with_fx :reverb, rate: 0.9, amp: 0.5 do
  if mode == 0 then
    play_pattern_timed [:C2,:Ds2,:B2,:C2], [0.5]
  elsif mode == 1 then
    play_pattern_timed [:C4,:E4,:B3,:D4,:A3,:C4, :G3,:B3], [0.5]
  else
     #sample :guit_e_fifths
     #play (chord :E4, :major)
     sleep 1
  end
  end
  end
end

define :drum do
  with_fx :reverb, rate: 0.5 do
    with_fx :level, amp: 0.34 do
      sleep 0.5
      sample :drum_heavy_kick
      play :G3
      sleep 0.5
      sample :drum_heavy_kick
      play :G4
    end
  end
end

define :clock do
  cue :tick
  sleep 2
  if mode >= 0 then 
  with_fx :level, amp: 0.34 do
    sample :drum_cymbal_closed
    sleep 0.5
    sample :drum_cymbal_closed
    sleep 0.5
  end
  else
    #play_pattern_timed (chord :C3, :major), [3*0.3]
    sample :drum_cymbal_pedal
    sleep 1
    #play_pattern_timed (chord :A3, :minor), [2*0.3]
    sample :drum_cymbal_pedal
    sleep 1
    #play_pattern_timed (chord :F3, :major), [2*0.3]
    sample :drum_cymbal_pedal
    sleep 1
  end
end

in_thread(name: :melody_t2) do
  loop{melody2}
end

in_thread(name: :melody_t3) do
  loop{melody3}
end


in_thread(name: :melody_t) do
  loop{melody}
end

in_thread(name: :drum_t) do
  loop{drum}
end

in_thread(name: :clock_t) do
  loop{clock}
end
"

osc("/fun", codes)
