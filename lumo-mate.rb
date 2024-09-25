a = 0
b = 0
c = 0
d = 0
espeed = 0.25
inobotf = false
drums = true

live_loop :amb do
  use_synth :piano
  with_fx :reverb, room: 1 do
    play choose(scale(:fs5, :major_pentatonic)), release: rrand(0.3,1.0), cutoff: rrand(60,130), amp: a
    sleep espeed
  end
end

live_loop :amb2 do
  use_synth :dark_ambience
  with_fx :reverb, room: 1 do
    play choose(scale(:fs5, :major_pentatonic)), amp: b
    sleep 0.125/2.0
  end
end

live_loop :amb3 do
  use_synth :organ_tonewheel
  with_fx :reverb, room: 1 do
    play choose(scale(:fs2, :major_pentatonic)), release: 0.2, cutoff: 100, amp: c
    sleep 1
  end
end

live_loop :drums do
  if drums then
    sample :drum_bass_soft, amp: d
    sleep 0.25
    if inobotf then
      sample :inobot_sample, amp: 1
    end
    sample :perc_snap, amp: d
    sleep 0.125
    sample :drum_bass_hard, amp: d
    sleep 0.125
    sample :drum_cymbal_closed, amp: d
    sample :drum_snare_soft, amp: d
    sleep 0.5
  else
    sleep 1.0
  end
end
