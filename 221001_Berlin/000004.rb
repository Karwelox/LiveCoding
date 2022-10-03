#00004
#___________________________



use_bpm 69 + 5

offset = 0
octaves = 3
patternHat = "x"
patternKick = "xx-xxx-"

define :pattern do |pattern|
  return pattern.ring.tick == "x"
end

live_loop :change do
  offset = choose([0,4,7,12])
  octaves = choose([2,3,4])
  
  if one_in(2)
    patternHat = "x"
    patternKick = "x-"
  else
    patternHat = "x-xx"
    patternKick = "xx-xxx-"
  end
  
  if one_in(6)
    patternHat = "xx--"
    patternKick = "x-xx"
  end
  
  sleep choose([4,2,1])
end


live_loop :main do
  
  att1 = 0
  att2 = 0.1
  rel1 = 0.05
  rel2 = 0.15
  ampGen = 2
  
  with_fx :reverb do
    synth choose([:fm, :tri]), note: (octs :e1 + offset , octaves).tick, attack:rrand(att1, att2), release: rrand(rel1, rel2), cutoff: (range 80, 100, steps:1).mirror.tick(:cutMain), amp: ampGen
    sleep 0.25
  end
  
end


#Kick
with_fx :reverb do
  live_loop :kick, sync: :main do
    
    with_fx :krush, mix: rrand(0.05,0.3) do
      sample :bd_tek, cutoff: 90, amp: 3 if pattern patternKick
    end
    sleep 0.25
  end
end


live_loop :drumSamplesOnset, sync: :kick do
  
  ampGen = 1
  rateSamp = 1
  if one_in(7) do
      rateSamp = -1
    end
  else rateSamp = 1
  end
  
  with_fx :echo, mix: 0.2 do
    sample :loop_compus, onset: pick, release: 0.01, amp: ampGen, attack: 0.1, rate: rateSamp
  end
  sleep 0.125
end

live_loop :arp, sync: :main do
  
  ampGen = 1
  with_fx :reverb, mix: 0.8 do
    notes = (scale :e3 + offset , choose([:enigmatic, :minor]) )
    synth :sine, note: notes.tick(:scale), release: 0.2, cutoff: (range 0, 110, steps: 5).mirror.tick(:tickArp) , amp:ampGen
    sleep 0.125
  end
end

live_loop :snare, sync: :kick do
  
  ampSnare = 0.5
  
  sleep 0.5
  with_fx :echo do
    with_fx :whammy, grainsize: rrand(0.2, 0.5)   do
      with_fx :reverb do
        sample :sn_dub, cutoff: 110, amp: ampSnare, rate: rrand(-0.75, -0.5)
      end
    end
  end
  sleep 3.5
end





live_loop :hiHat, sync: :kick do
  
  ampHat = 6
  with_fx :krush do
    sample :drum_cymbal_closed, cutoff: 60, amp: ampHat   if pattern patternHat
  end
  sleep 0.125
end



live_loop :samples, sync: :main do
  
  ampSamp = 2.5
  with_fx :reverb, mix: rrand(0.8, 1) do
    with_fx :echo, mix: rrand(0.5, 0.75), decay: rrand(3, 6), mix: 1 do
      with_fx :krush, mix: rrand(0.75,1) do
        #with_fx :panslicer, mix: rrand(0.1,0.7) do
        
        sample :ambi_soft_buzz, beat_stretch: 4, rate: -1, amp: 1.2
        
        sample :ambi_piano, rate: -1, pan: (range -1,1).shuffle.tick, attack: 1, pitch: rrand(0,12), amp: ampSamp * rrand(0.5, 0.9) if one_in(3)
        
        with_fx :bitcrusher, mix: rrand(0.2, 0.9), mix: 0.75 do
          sample :loop_weirdo, beat_stretch: rrand(0.95,4), pan: (range -1,1).shuffle.tick(:tickSamp), pitch: rrand(0,12), amp: ampSamp * rrand(0.5, 0.9) if one_in(2)
        end
        sample :ambi_glass_hum, start: 2, finish: 6, pitch: rrand(-12,12), amp: ampSamp * rrand(0.5, 0.9), pan: (range -1,1).shuffle.tick if one_in(4)
        sleep 4
        
        #end
      end
    end
  end
end



