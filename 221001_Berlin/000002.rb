#000002
#________________


offset = 0

use_bpm 67

l1 = :loop_amen
l2 = :loop_weirdo
l_kick = :bd_tek
sd1 = sample_duration (l1)
sd2 = sample_duration (l2)

define :pattern do |pattern|
  return pattern.ring.tick == "x"
end

live_loop :defaultStart do
  sleep 4
end

live_loop :choose_note,  sync: :defaultStart do
  offset = choose([0, 4, 7, 12, -7, -4, 3, 6])
  sleep 4
end


live_loop :samplesWeido do
  
  with_fx :gverb, mix: rrand(0.75, 1) do
    with_fx :echo, mix: rrand(0.5, 1), phase: choose([0.25, 0.5, 1, 1.5]), decay: 3 do
      sample :loop_weirdo,
        amp: rrand(0.75,1) + 0.5,
        rate: rrand(-1, 0.5),
        pan: rrand(-1, 1),
        attack: 2,
        cutoff: rrand(50, 110),
        release: 2,
        start: 0,
        finish: 4
    end
  end
  sleep 8
end



live_loop :samplesAmbient, sync: :defaultStart do
  
  if one_in(2)
    with_fx :echo, mix: rrand(0.5,0.6) do
      #with_fx :krush, mix: choose([0.25, 0.5, 0.75]) do
      with_fx :gverb, mix: rrand(0.4, 0.7), amp: 0.5 do
        sample choose([:loop_mehackit2, :loop_mehackit1]),
          beat_stretch: rrand(0.96, 1.06),
          rate: rrand(-1, 1),
          pan: rrand(-1,1),
          amp: rrand(0.5, 0.75),
          start: 0,
          finish: 4
      end
    end
    #end
  else
    with_fx :flanger, mix: 0.5 do
      #with_fx :wobble, mix: rrand(0.1,0.2) do
      with_fx :echo, mix: rrand(0.4,0.95), phase: choose([0.125, 0.5, 0.75]) do
        sample :ambi_drone, attack: 1, release: 3, beat_stretch: rrand(0.98, 1), amp: 0.75, start: 0, finish: 4
        sample :ambi_drone, attack: 3, release: 1, beat_stretch: rrand(0.75, 1), amp: 0.75,  start: 0, finish: 2
        sample :ambi_drone, attack: 2, release: 2, rate: rrand(-1, -0.5), pitch_dis:rrand(0.1, 0.75), amp: 0.5,  start: 0, finish: 4
        
      end
    end
    #end
  end
  
  sleep choose([4,8])
end


live_loop :bassProphet, sync: :defaultStart do
  
  ampBass = 0.5
  
  pitchDis1 = -0.5
  pitchDis2 = 0.5
  
  use_synth :prophet
  with_fx :echo do
    with_fx :distortion, distort: 0.75 do
      with_fx :reverb, mix: 0.75 do
        play :e2, release: 8, attack: 2, cutoff: (range 60,70, step:5).mirror.tick(:bassP), amp:ampBass, pitch: rrand(-pitchDis1,pitchDis2)
      end
    end
  end
  sleep 16
end


live_loop :hiHatPanned, sync: :defaultStart do
  
  with_fx :reverb  do
    with_fx :echo, mix: rrand(0.1,0.5), phase: 0.125 do
      sample :loop_amen,
        onset: pick,
        pan: (range -1,1, 0.125).mirror.tick(:panTickDrums),
        release: rrand(0.1,0.125),
        rate: -0.95,  #don't stretch too match
        amp: 0.2
    end
  end
  
  sleep 0.25
end









live_loop :snare, sync: :defaultStart do
  
  #with_fx :krush, mix:0.25 do
  with_fx :echo  do
    with_fx :reverb do
      #sample :sn_dub, beat_stretch: 0.5, amp: 1, cutoff: 90 if pattern "-x-x"
      sample :sn_dub, beat_stretch: choose([0.5,1]), amp: 2.5, cutoff: 100  if pattern "---x------------"
      sleep 0.25
      
    end
    
  end
  #end
end




live_loop :arp_bass, sync: :defaultStart do
  
  ampArpBass =  3
  #with_fx :reverb, mix: rrand(0.25, 0.6) do
  synth choose([:fm, :sine]),
    note: (octs :e2,2).tick(:arpBass)+offset,
    release: rrand(0.05,0.125)   ,
    attack: 0,
    cutoff: rrand(50, 75) + 15,
    amp: ampArpBass * rrand(0.6, 0.9) ,
    pan: (range 1,-1, 0.1).mirror.tick(:panArpBass)
  sleep 0.125
  #end
  
end



live_loop :arp, sync: :defaultStart do
  
  ampArp = 3
  with_fx :reverb, mix: 0.25 do
    notes =  (scale :e4 + offset, :minor).values_at(0, 2, 4, 3, 5, 6)
    synth choose([:sine, :tri]),
      note: notes.tick,
      attack: 0.05,
      release: rrand(0.01, 0.025),
      pan: (range -1, 1, step:0.125).mirror.tick(:arpTick),
      cutoff: rrand(90, 110),
      amp: ampArp * rrand(0.1, 0.3)
    sleep 0.125
  end
end


with_fx :reverb do
  live_loop :kick, sync: :defaultStart do
    
    amp_kick = 3
    cutOffset = 10
    
    2.times do
      sample l_kick, amp: amp_kick, cutoff: rrand(70,95) + cutOffset
      sleep 0.5
    end
    
    with_fx :echo, phase: 0.125 do
      2.times do
        sample l_kick, amp: amp_kick, cutoff: rrand(70,95) + cutOffset
        sleep 0.25
      end
    end
    
    
  end
end













