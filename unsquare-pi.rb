define :sequence do |xs,tp|
  xs.each do |ys|
    print ys
    in_thread do
      if (ys[0] == :zawa || ys[0] == :tb303 || ys[0] == :pulse) then
        synth = ys[0]
        zs = ys[1..-1]
      else
        synth = :tri
        zs = ys
      end
      with_synth synth do
        zs.each do |y|
          case y
          when :r
          when :cs
            sample :drum_cymbal_soft
          when :co
            sample :drum_cymbal_open
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
            play y, release: (1.5 * (tp / zs.length))
          end
          sleep (tp / zs.length)
        end
      end
    end
  end
  sleep tp
end

define :main do
  [0,0,5,0,7,0].each do |x|
    use_transpose x
    bass  = [:a2,:r ,:g2,:r ,:a2,:r ,:r]
    with_fx :reverb, level: 1.0, mix: 0.6 do
        drums = [:bs,:cc,:bs,:cc,:bs,:cc,:cc]
        snare = [:r ,:r ,:r ,:r ,:r ,:ss,:ss]
        snareh = [:r ,:r ,:r ,:r ,:r ,:sh,:sh]
        bassh  = [:a3,:r ,:g3,:r ,:a3,:r ,:r]
        toms = [:tls,:ths,:tls,:r,:ths,:r,:ths]
        piano = [:b4,:r,:r,:b4,:r,:r,:g4,:a4,:g4,:e4,
                 :r,:r,:d4,:e4,:r,:r,:d4,:e4,:r,:r]
        sequence [bass,bass,bassh,bassh,snare,snare,snareh,
                  piano,piano,drums+drums,drums+drums,
                  toms,toms,drums,drums,drums], 2.0
      end
    end
end

  in_thread(name: :dx) do
    loop{main}
  end
