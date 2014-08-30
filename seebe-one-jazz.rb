defonce :out do
  OSC::Client.new("10.0.0.8", 8113)
end

define :osc do |m, v|
  out.send(OSC::Message.new(m, v))
end


codes = "

mode = 2

end1 = false

scale = [:C3, :Ds3, :F3, :Fs3, :G3, :Bf3, :C4]
scale2 = [:C3, :Ds3, :F3, :Fs3, :G3, :Bf3]
scaleN = scale + scale2.reverse + scale + scale2.reverse 

scaleN = scaleN[0..3]  + scaleN[14..18] + scaleN[4..8] + scaleN[12..14] + scaleN[8..12]

tp = 1.0

define :dotransp do
  use_transpose 22
end

define :melody3 do
 dotransp()
 sleep tp
end

define :melody2 do
 dotransp()
 sleep tp
 
end

define :melody do
  dotransp()
  with_synth :tri do
  with_fx :reverb, rate: 0.6, amp: 0.1  do
  if mode == 0 then
  16.times do |i|
    play [scaleN[i],scaleN[i+rrand_i(0,4)*2]]
    sleep (tp/8.0)
  end
  elsif mode == 1 then
    play_pattern_timed scale, [tp/4.0]
    sleep tp
  else
    play_pattern_timed scale[0..4], [tp/4.0]
  end
  end
  end
end

define :drum do
  sleep tp
  if !end1 then
  with_fx :reverb, amp: 0.5 do
     sample :drum_tom_hi_soft
     sleep tp/4.0
     sample :drum_tom_hi_hard
     sleep tp/4.0
     sample :drum_tom_hi_soft
     sleep tp/2.0
     end
     else
     sleep tp
     end
end

define :clock do
  cue :tick
  with_fx :reverb, amp: 0.5 do
   sample :drum_tom_hi_hard
   sleep tp/8.0
   sample :drum_bass_hard
   sleep tp/4.0   
   sample :drum_tom_hi_soft
   sleep tp/8.0
   sample :drum_tom_mid_hard
   sleep tp/4.0
   sample :drum_bass_hard
   sleep tp/8.0
   sample :drum_bass_hard
   sleep tp/8.0
  end
  sleep tp
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
