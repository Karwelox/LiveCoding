#000001
#___________________________



use_bpm 63
bass_note = :d1
mode = :minor



define :changeHarmony do
  
  bass_note = choose([:d1,  :d1, :f1, :g1])
  
  if(bass_note == :d1)
    mode = :minor
  end
  
  if (bass_note == :f1)
    mode = :m7
  end
  
  if (bass_note == :g1)
    mode = :minor
  end
  
  if (bass_note == :c1)
    mode = :minor
  end
  
  
end

live_loop :haunted do
  
  #with_fx :whammy, mix: 0.5, grainsize: 0.5 do
  with_fx :echo, mix: rrand(0.3,0.5), phase: choose([0.25, 0.5, 1.5]) do
    with_fx :gverb, amp: 0.5, mix: rrand(0.5, 1) do
      sample :perc_bell, rate: rrand(-1.5, 1.5), beat_stretch: rrand(0.95, 1.05), amp: rrand(0.9, 1.5), pan: rrand(-1,1)
      sleep choose([0.25, 1, 2, 0.5])
    end
  end
  
  #end
  
end



live_loop :bass do
  
  
  cutOff1 = 35
  cutOff2 = 50
  
  #with_fx :wobble, mix: rrand(0.01,0.2), phase: choose([0.5, 1]) do
  #with_fx :tremolo, mix: rrand(0.1, 0.4) do
  with_fx :echo, mix: 0.4 do
    with_fx :reverb, mix: 0.4 do
      
      synth choose([:tb303, :prophet]), note: bass_note, release: 8, cutoff: rrand(cutOff1,cutOff2),
        cutoff_attack: 2,
        cutoff_sustain: 2,
        cutoff_release: 4,
        amp: 2
      
      sleep 8
    end
  end
  #end
  #end
  
  changeHarmony
  #end
end







live_loop :melody, sync: :bass do
  
  ampMelody = 0.5
  
  use_synth :sine #choose([:winwood_lead, :pulse])    #:organ_tonewheel, :fm
  use_synth_defaults cutoff: rrand(70,90), attack: 0.01 #, detune: rrand(-0.1, 0.2)
  
  #with_fx :whammy, mix: 0.5, grainsize: rrand(0.01,0.5) do
  with_fx :reverb, mix: 0.5 do
    with_fx :echo, phase: 0.5, decay: 4, mix: 0.75, mix: rrand(0.5, 1) do
      
      play choose([:D3, :E3, :F3, :C4]), amp: ampMelody
      sleep choose([ 1,0.5])
      sample :elec_plip, amp: rrand(0.25, ampMelody)
      sleep 0.25
      play choose([:D4,:C3, :A3, :BB4]), amp: ampMelody
      sleep choose([0.5, 1])
      play choose([:A4, :E3, :F4]), amp: ampMelody
      sleep choose([0.25, 0.5])
    end
  end
  #end
end


live_loop :arpKalimba, sync: :bass do
  
  ampKal = 6
  #with_fx :bitcrusher, mix: 1 do
  notes =  (chord bass_note + 12 * 4, mode, num_octaves: 2) #.values_at(0, 2, 3, 5, 6)
  synth choose([:kalimba]),
    note: notes.mirror.tick,
    release: rrand(0.01,0.125),
    pan: (range -1, 1, step: 0.125).mirror.tick,
    cutoff: rrand(50, 120),
    attack: 0.1,
    amp: rrand(0.3, 0.8) + ampKal
  sleep 0.25
  #end
end



live_loop :hiHat, sync: :bass do
  
  with_fx :echo, phase: 0.5, mix: 0.4 do
    sample  :drum_cymbal_soft, release: 0.01, amp: rrand(0.01, 0.2) #rate: rrand(0.5, 0.7)
    sleep 0.125
  end
end


live_loop :kick, sync: :bass do
  
  #with_fx :bitcrusher, mix: 0.5 do
  with_fx :reverb, mix: 0.1 do
    sample :bd_gas, amp: 4, cutoff: 85
  end
  #sleep choose([0.25, 0.5])
  sleep 0.5
  #end
end




