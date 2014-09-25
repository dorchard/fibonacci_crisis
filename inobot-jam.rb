factor = 16.0

tp = sample_duration(:inobot_sample) / (factor*2.0)

slicer_sample = true
samples = true
drumso = true
melodyo = true

define :sampler do
  sync :tick
  with_fx :reverb, level: 0.3 do
    if slicer_sample then
      with_fx :slicer, mix: 0.0, rate: tp*4.0 do
        sample :inobot_sample, amp: 0.0, rate: 0.5
      end
    end
    if samples then
      sample :inobot_sample, amp: 0.2, rate: -6
      sample :inobot_sample, amp: 0.3, rate: -2
      sample :inobot_sample, amp: 0.5, rate: -1
      sleep (tp * 8.0)
    end
  end
end

define :melody do
  use_transpose 0
  sync :tick
  if melodyo then
    with_fx :slicer, rate: tp*2.0, mix:0.12 do
      with_synth :fm do
        with_fx :reverb, level: 0.8, mix: 1.0 do
          play [:fs4,:as4,:fs3,:fs2,:fs5], amp: 0.35
          sleep tp*1.6
          play [:cs3,:as4,:as3,:es5,:as2], amp: 0.25
          sleep tp*1.8
          play [:as3,:as4,:cs2,:ds4,:ds5], amp: 0.55
          sleep tp*2.2
          play [:fs3,:as4,:ds3,:ds5,:es5], amp: 0.25
          sleep tp*2.4
        end
      end
    end
  end
end

define :drums do
  cue :tick
  if drumso then
    sample :drum_cymbal_closed, amp:0.24
    sample :drum_bass_soft, amp: 0.24
    sample :drum_bass_hard
    sleep tp
    sample :drum_bass_soft, amp: 0.24
    sleep tp
    sample :drum_cymbal_closed, amp:0.5
    sleep tp
    sample :drum_cymbal_closed, amp:0.5
    sleep tp
  else
    sleep tp
  end
end

in_thread(name: :foo) do
  loop{sampler}
end

in_thread(name: :drumsa) do
  loop{drums}
end

in_thread(name: :foo2) do
  loop{melody}
end
