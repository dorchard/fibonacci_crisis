define :sequence do |xs,tp|
  xs.each do |ys|
    in_thread do
      if (ys[0] == :zawa || ys[0] == :tb303 || ys[0] == :pulse || ys[0] == :s) then
        synth = ys[0]
        zs = ys[1..-1]
      else
        synth = :tri
        zs = ys
      end
      if synth == :s then
        zs.each do |z|
          if (z == :r) then
          else
            z.call(())
          end 
          sleep (tp / zs.length)
        end
      else 
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
              play z, release: 2*tpp
            end
            sleep tpp
          end
          end
        end
      end
    end
  end
  sleep tp
end


k = 1.6

live_loop :druma do
  sequence [[:bh, :r, :bh, :r],
            [:cc, :cc, :cc, :r, :cc, :r, :cc, :cc]], k
end

live_loop :foo do
  f = lambda do |x| sample :loop_compus, start: 0, finish: 0.1 end
  g = lambda do |x| sample :loop_industrial, start: 0.9, finish: 1.0 end
  h = lambda do |x| sample :loop_amen, start: 0.8, finish: 0.84 end
  4.times do
  sequence [[:s, f, :r, :r, :r, f, f, :r, :r], 
            [:s, :r, :r, g, g, :r, :r, g, :r]], k
  end
  4.times do
  sequence [[:s, f, :r, f, :r, g, f, :r, :r], 
            [:s, :r, g, :r, h, :r, :r, f, :r]], k   
  end
  2.times do
  sequence [[:s, :r, :r, :r, g],
            [:cc, :r, :cc, :r]], k
  end
  2.times do
  sequence [[:bs, :r, :bs, :r],
            [:s, :r, g]], k
  end
end

live_loop :tototn do
  sequence [[:bh, :r, :r, :r]], k*2
end

live_loop :kka do
  with_fx :reverb, amp: 0.4 do
  h = lambda do |x| sample :loop_amen, start: 0.2, finish: 0.25, rate: 1 end
  sequence [[:s, h, :r, h, h, h, :r, h, :r],
            [:s, h, :r, h, :r, h, :r, h, :r]], k*2
  end
end

mode = 2

live_loop :auma do
  l = lambda do |x| sample :inobot_sample, start: 0.4, finish: 0.47, rate: -0.5 end
  m = lambda do |x| sample :inobot_sample, start: 0.37, finish: 0.47, rate: -0.75 end
  n = lambda do |x| sample :inobot_sample, start: 0.64, finish: 0.67, rate: -1 end
  
  if mode == 0 then 
    sequence [[:s, :r, n, l, :r]], 1.6
  else
    if mode == 1 then 
    sequence [[:s, l, :r, l, m, :r, :r, m, m]], 3.2
    else
    if mode == 2 then
    sequence [[:s, n, n, :r, n, :r, n, :r, :r],
              [:s, n, n, :r, n, :r, n, :r, :r], 
              [:s, m, :r, :r, :r, n, :r, :r, :r],
              [:s, m, :r, :r, :r, n, :r, :r, :r]], 1.6
    else
      #sample :inobot_sample, rate: -0.25
      #sample :inobot_sample, rate: -0.125
      sleep 12.8
    end
    end
  end   
end
