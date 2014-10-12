define :sequence do |xs,tp|
  xs.each do |ys|
    in_thread do
      if (ys[0] == :zawa || ys[0] == :tb303 || ys[0] == :pulse) then
        synth = ys[0]
        zs = ys[1..-1]
      else
        synth = :tri
        zs = ys
      end
      with_synth synth do
        tpp = (tp / zs.length)
        zs.each do |y|
          if (y.is_a?(Array)) then
            w = y
            tpp = tpp / y.length
          else
            w = [y]
            tpp = tpp
          end
          w.each do |z|
            case z
            when :r
            when :cs
              sample :drum_cymbal_soft
            when :co
              sample :drum_cymbal_open, amp: 0.4
            when :cp
              sample :drum_cymbal_pedal
            when :ch
              sample :drum_cymbal_hard
            when :cc
              sample :drum_cymbal_closed
            when :bh
              sample :drum_bass_hard
            when :bs
              sample :drum_bass_soft
            when :sh
              sample :drum_snare_hard
            when :ss
              sample :drum_snare_soft
            when :thh
              sample :drum_tom_hi_hard
            when :ths
              sample :drum_tom_hi_soft
            when :tlh
              sample :drum_tom_lo_hard
            when :tls
              sample :drum_tom_lo_soft
            when :tmh
              sample :drum_tom_mid_hard
            when :tms
              sample :drum_tom_mid_soft
            when :eb
              sample :elec_beep
            when :ehk
              sample :elec_hollow_kick
            else
              play z, release: (3 * tpp)
            end
            sleep tpp
          end
        end
      end
    end
  end
  sleep tp
end

tp = sample_duration(:inobot_sample)/16.0
mode = 0

define :sampler do
  sync :tick
  with_fx :reverb, level: 0.8, amp: 1.7 do
    if mode == 0 then 
    #sample :inobot_sample2
    sample :inobot_sample, rate: -0.5
    #sample :inobot_sample, rate: -2
    sample :inobot_sample, rate: -1
    #sample :inobot_sample2
    sleep tp*16.0
    else
      #sample :inobot_sample2
      sample :inobot_sample
      drums = [:bs, :r, :r, :r, :bs, :bs, :r, :r]
      drums2 = [:cc,:bs,:r,:r,:bs,:cc,:r,:r]
      sequence [drums+drums2+drums+drums2+drums2+drums+drums+drums2], tp*16
    end
  end
end

define :melody do
  with_fx :reverb, level: 4.0, amp: 0.45 do
    if (mode == 0) then  
    #[0,-5,-10,-12,0,2,4,0,0,4,2,0]
      [0,-5,-10,-12,0,4,2,0].each do |x| 
        use_transpose x
        sync :tick
        with_fx :pan do
        with_fx :slicer, rate: tp*2, mix: 1.0 do
        with_fx :echo, rate: tp*2.0, mix: 1.0 do
        with_fx :reverb, level: 4.0, mix: 1.0 do
        top = if x == 4 then :e5 else :ds5 end
        melody = [:fs4,:fs4,:fs4,:fs4,top, top, top, top]
        sequence [melody], tp*2
      end
    end
    end
    end
    end
    else
      sequence [[:fs4,:as4,:cs4,:as4,:gs4,:cs4,:as4,:cs4]], tp*2
    end
  end
end

define :bass do
  sync :tick
  with_fx :reverb, level: 4, amp: 1.0 do
    if (mode == 0) then 
      sleep tp*4
    else
      play :as2, release: tp*2.4, amp: 1.6
      sleep tp*2
      play :fs2, release: tp*2, amp: 1.6
      sleep tp*2
      play :ds2, release: tp*2, amp: 1.6
      sleep tp*2
      play :cs2, release: tp*2, amp: 1.6
      sleep tp*2
    end
  end
end

define :drumo do 
  sync :tick
  with_fx :reverb, level: 2.9, amp: 0.7 do 
  
    drums = [:cc,:cc]
    drums3 = [:r, :ss, :ss, :r]
    drums2 = [:bs, :r, :bs, :r]
    if (mode == 0) then
        sequence [drums], tp*2
        #sample :drum_bass_hard
        #sleep 100 # end rest
    else
        sequence [drums], tp
    end
  
  end
end

in_thread(name: :drumso) do
  loop{drumo}
end

define :melody2 do
  sync :tick
end

define :ticker do
  cue :tick
  sleep tp
end

in_thread(name: :foo) do
  loop{sampler}
end

in_thread(name: :melod2) do
  loop{melody2}
end

in_thread(name: :basso) do
  loop{bass}
end

in_thread(name: :melod) do
  loop{melody}
end

in_thread(name: :ticc) do
  loop{ticker}
end
