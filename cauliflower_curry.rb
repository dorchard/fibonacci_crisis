define :transp do
  use_transpose 0
end

mode = 0

live_loop :high_part do
  sync :ticktick
  with_synth :tri do
    play chord(:c4, "major7").choose, amp: 0.6, release: 0.2, cutoff: 0.8
  end
end

live_loop :melody do
  transp
  use_random_seed(10)
  with_fx :reverb, level: 2.0 do
    if mode == 0 then
      4.times do |y|
        x = chord(:c2, "major7").choose
        #play x, amp: 1.0, release: 2.0
        sleep 1.0
      end
    else
      sleep 0.125
      cue :ticktick
    end
  end
end

live_loop :foo do
  transp
  if mode == 0 then
    use_random_seed(5125) # 5125 is good, and 52
    n = 4
  else
    use_random_seed(1009)
    n = 2
  end
  t = 0
  while (t < n) do
      with_fx :reverb do
        with_fx :distortion, distort: 0.3, distortion_slide: 0.5 do
          play chord(:c3, "major7").choose, release: 0.25
          p = [1,2].choose*0.125
          sleep p
          t = t + p
          play chord(:g4, "major7").choose, release: 0.25
          sample :drum_heavy_kick, amp: 2.5 if mode == 0 and [1,2].choose == 1
          q = [1,2].choose*0.125
          sleep q
          t = t + q
        end
      end
    end
  end

  live_loop :drums do
    if mode == 0 then
      sample :drum_snare_soft
      sleep 2.25
      sample :drum_cymbal_closed
      sleep 1.25
      sample :drum_bass_soft
      sleep 0.25
      sample :drum_bass_soft
      sleep 1.25
    else
      sleep 1.0
      sample :drum_cymbal_closed
    end
  end

  live_loop :drums3 do
    if mode == 0 then
      sample :loop_industrial, start: 0.5, finish: 1.0
    else
      sample :drum_bass_hard
      sleep 0.125
      sample :drum_heavy_kick
      sleep 0.125
      sample :drum_bass_hard
      sleep 0.5+0.25
    end
    sleep 1.0
  end
