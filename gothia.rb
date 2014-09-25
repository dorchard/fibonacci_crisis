define :tp do
  tp = 0.5
end

x = 0

define :transp do
  x = ((x + 1) % 4) * 2
  use_transpose x
end

bass_flag = false

define :bass do
  transp
  sync :tick
  if bass_flag then
    with_fx :compressor, level: 0.9 do
      with_synth :tri do
        with_fx :reverb, level: 0.9 do
          [:B3,:Fs3,:As3,:Ds3].each do |x|
            play [x, (note x) - 12, x, (note x) - 24, x]
            sleep tp*(2.0/7)*8
          end
        end
      end
    end
  else
    with_fx :level, release: 0.2 do
    sleep tp/2.0
    sample :elec_fuzz_tom
    sleep tp/4.0
    sample :elec_twip
    sleep tp/4.0
    #sleep (tp*(2.0/4.0) - tp*(2.0/5.0))
    #play [:D2]
    #sleep tp/4.0
    end
  end
end

mode = 0

define :arpeg do
  transp
  sync :tick
  [:Fs4, :Gs4, :As4, :Gs4].each do |x|
    with_synth :tb303 do
        with_fx :reverb, level: 0.1, amp: 0.3, release: 0.2 do
          if mode == 0
            2.times do
              play_pattern_timed [:B3,:Ds4,x,:Ds4], [tp*(4/7.0)]
            end
          elsif mode == 1
            2.times do
              play_pattern_timed [:B3,:Ds4,x,:Ds4], [0]
              sleep tp*2
            end
          end
        end
    end
  end
end

define :ticker do
  cue :tick
  sleep tp/2.0
end

define :drums do
  sync :tick
  f = 7
  0.times do |x|
    with_fx :reverb, level: 0.5 do
      sample :drum_cymbal_pedal
      sleep (tp/f)*8.0
      if x==4
        sample :drum_bass_hard
      end
    end
  end
  sample :drum_bass_hard
  sleep tp*2
end

define :drums2 do
  sync :tick
  sleep tp/3.0
  sample :drum_tom_lo_soft, level: 0.5
  #sleep tp/4.0s
  sleep tp*(2/3.0)
end

in_thread(name: :a) do
  loop{arpeg}
end

in_thread(name: :basst) do
  loop{bass}
end

in_thread(name: :drumst) do
  loop{drums}
end


in_thread(name: :tickert) do
  loop{ticker}
end

in_thread(name: :drumst2) do
  loop{drums2}
end
