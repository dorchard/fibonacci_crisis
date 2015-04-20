live_loop :conductor do
  cue :clock
  sleep 0.5
end

live_loop :sample do
  sync :clock
  sample :inobot_sample, rate: -0.5
  sleep 8
end

live_loop :melody do
  sync :clock
  [0,-5,-10,-12].each do |x|
    use_transpose x
    with_fx :reverb, amp: 0.45 do
      cue :conductor2, note: x
      4.times do
        play :fs4
        sleep 0.25
      end
      4.times do
        play :ds5
        sleep 0.25
      end
    end
  end
end

live_loop :drums3 do
  sync :clock
  sample :drum_cymbal_closed
  sleep 0.25
  
  sample :drum_bass_hard
  sleep 0.5
end

live_loop :drums2 do
  sync :clock
  sample :drum_cymbal_closed
  sleep 1.0
end

live_loop :drums do
  sync :clock
  sample :bd_tek
  sleep 0.25
end
