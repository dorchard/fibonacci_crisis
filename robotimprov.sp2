# Welcome to Sonic Pi v2.0

scale = [:B1, :Cs2, :Ds2, :Fs2, :Gs2, :As2,
           :B2,
           :Cs3, :Ds3, :Fs3, :Gs3, :As3,
           :B3,
           :Cs4, :Ds4, :Fs4, :Gs4, :As4,
           :B4,
           :Cs5, :Ds5, :Fs5, :Gs5, :As5,
           :B5,
           :Cs6, :Ds6, :Fs6, :Gs6, :As6]

define :improviser do |instrument, reverb, level, length, mode_rate|
  # Set up the instrumentation
  use_synth instrument
  with_fx :reverb, rate: reverb do
  with_fx :level, amp: level do 
  
  # 'i' is out current note
  i = (scale.length / 2.0).to_int
  # 't' is the default time period (length of a standard note)
  t = 0.28
  # Initisalise the current 'phrase'
  phrase = []

  100.times do
    # Choose which mode we are in:
    #   0 is improvise
    #   1-mode_rate is 'repeat' mode
    mode = rrand_i(0,mode_rate)
    if mode==0 then
      # IMPROVISE MODE

      # choose a phrase length: 0, 2, 4, 8
      phrase_len = rrand_i(0,length)*2
      # choose a direction: either up (1) or down (-1)
      direction = rrand_i(0,1)*2 - 1
      # timing of our notes
      tp = (t*4)/phrase_len

      # point the direction away from overflowing or underflowing
      direction = -1 if (phrase_len + i >= scale.length)
      direction = 1 if (i - phrase_len <= 0)

      # empyty the phrase
      phrase = []
        
      phrase_len.to_int.times do
        # choose the central note of the chord
        notes = [i]
        # Choose possible additional notes in a triad
        notes.push(i+4) if rrand_i(0,3) == 1 && (i+4 < scale.length)
        notes.push(i-4) if rrand_i(0,3) == 1 && (i-4 >= 0)
        notes.push(i+2) if rrand_i(0,6) == 3 && (i+2 < scale.length)
        notes.push(i-2) if rrand_i(0,6) == 3 && (i-2 >= 0)
        # Play the chord
        notes.each do |note|
          play scale[note]
        end
        sleep tp
          
        # Move up or down the phrase
        i = i + direction

        # Add the chord to the phrase
        phrase.push([notes,tp])
    end

  else
    # REPEAT MODE
    print "repeat mode"

    # Calculate an amount to transpose the phrase by
    transp = rrand_i(0,4)-2

    # Assuming we have already calculated a phrase
    if phrase != [] then

      # play each chord in the phrase + the transpose
      phrase.each do |notes, tp|
        notes.each do |note|
          # Play notes of the chord if transposing doesn't cause overflow/underflow
          play scale[note + transp] if ((note + transp >= 0) && (note + transp < scale.length))
        end
        sleep tp
      end
    end
    end
    end
end
end
end

in_thread(name: :improv1) do
  loop{improviser(:fm,1.0,0.1,2,10)}
end

in_thread(name: :improv2) do
  loop{improviser(:tri,0.4,0.9,4,5)}
end

