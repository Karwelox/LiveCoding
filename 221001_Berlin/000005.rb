#000005
#___________________________



use_bpm 133


scales = (ring :g4, :b3, :a3, :fs4)
synths = [:sine, :prophet]
note = :g4
cur_synth = :prophet
currScale = :minor

sample_sauna = :ambi_sauna
sample_kick = :bd_ada
sample_hat = :drum_cymbal_closed

sd1 = sample_duration(sample_sauna)


live_loop :choose_note do
  note = choose(scales)
  cur_synth = choose(synths)
  currScale = :minor #choose([:enigmatic, :minor, :major])
  sleep 4
end


with_fx :reverb do
  live_loop :kick do
    with_fx :krush, mix: 0.5, cutoff: 40, amp:4 do
      sample :bd_sone, cutoff: 90, amp: 2
      sleep 1
    end
  end
end


live_loop :kick2, sync: :kick do
  
  
  rel1 = 90
  rel2 = 120
  
  with_fx :bitcrusher, mix: 0.4 do
    with_fx :compressor, amp: 4 do
      with_fx :reverb, mix: 0.25 do
        sample sample_kick, cutoff: rrand(rel1,rel2)
        sleep 0.5
        sample sample_kick, cutoff: rrand(rel1,rel2)
        sleep 1.5
        sample sample_kick, cutoff: rrand(rel1,rel2)
        sleep 0.25
        sample sample_kick, cutoff: rrand(rel1,rel2)
        sleep 0.25
        sample sample_kick, cutoff: rrand(rel1,rel2)
        sleep 0.5
      end
    end
  end
end


live_loop :snare, sync: :kick do
  
  snare_amp = 3
  
  with_fx :krush, mix: rrand(0.15, 0.5)do
    with_fx :reverb, mix: 0.1 do
      3.times do
        sleep 0.5
        sample :elec_snare  , cutoff: 90, amp: snare_amp
        sleep 3.5
      end
      2.times do
        sleep 0.5
        
        sample :elec_snare  , cutoff: 90, amp: snare_amp
        
        sleep 3
        with_fx :echo do
          sample :elec_snare  , cutoff: 90, amp: snare_amp
        end
        sleep 0.25
        sample :elec_snare  , cutoff: 90, amp: snare_amp
        sleep 0.25
        
      end
    end
  end
  
end


live_loop :bass, sync: :kick do
  
  ampBass = 1
  
  pitchDis1 = -0.5
  pitchDis2 = 0.5
  
  use_synth :prophet
  with_fx :echo do
    with_fx :distortion, distort: 0.75 do
      with_fx :reverb, mix: 0.75 do
        play note-24, release: 8, attack: 2, cutoff: (range 60,95, step:5).mirror.tick(:bass), amp:ampBass, pitch: rrand(-pitchDis1,pitchDis2)
      end
    end
  end
  sleep 8
end




live_loop :arp, sync: :kick do
  
  ampArp = 0.5
  with_fx :echo, phase: 0.25, mix:0.25 do
    with_fx :reverb, mix: 0.5 do
      use_synth choose([:gnoise, :sine])    #gnoise, zawa
      play (scale note, currScale).mirror.tick, cutoff: (range 90, 125, step: 0.5).mirror.tick(:arpCutTick), pan: rrand(-1,1), amp: ampArp, release: rrand(0.01, 0.75), attack: 0.01
      sleep 0.25#choose([0.25, 0.5])
    end
  end
end





live_loop :sampleAmb, sync: :kick do
  
  ampSamp = 3
  #with_fx :krush, mix: 0.8 do
  with_fx :echo, mix: rrand(0.1,1), phase: choose([0.25, 0.5, 0.75,1]) do
    with_fx :reverb, mix: rrand(0.5, 1) do
      #with_fx :panslicer, wave: 3, phase: choose([0.5,0.75,1]), mix: 0.4 do
      sample sample_sauna, rate: rrand(-0.5,0.5), amp: rrand(0.25, 0.5)* ampSamp if one_in(2)
      sample :ambi_drone, rate: [0.25, 0.5, 0.125, 1].choose, amp: rrand(0.5, 0.9) * ampSamp, beat_stretch: rrand(0.1,4), pitch_dis: rrand(-1,1) #if one_in(8)
      sample :ambi_lunar_land, rate: [0.5, 0.125, 1, -1, -0.5].choose, amp: rrand(0.15, 0.5) * ampSamp if one_in(3)
      #end
    end
  end
  #end
  sleep 8 #sd1
  
end


live_loop :hihat, sync: :kick do
  
  hiHatAmp = 8
  
  12.times do
    sample sample_hat, cutoff: rrand(90, 120) - 20
    #sample :elec_blip2, start: 0, finish: rrand(0.125,0.25), cutoff: rrand(80, 100), amp: hiHatAmp, rate: choose([-1,1]) if one_in(2)
    sleep 0.25
  end
  
  with_fx :echo, mix: 1 do
    2.times do
      sample sample_hat , cutoff: rrand(80, 100), amp: hiHatAmp
      #sample :elec_blip2, start: 0, finish: rrand(0.125,0.25), cutoff: rrand(80, 100), amp: hiHatAmp, rate: choose([-1,1]) if one_in(5)
      
      sleep 0.5
    end
  end
  
  4.times do
    sample sample_hat, cutoff: rrand(100, 130), rate: choose([0, -1]), amp: hiHatAmp
    sample :elec_blip, start: 0, finish: rrand(0.125,0.25), cutoff: rrand(80, 100), amp: hiHatAmp if one_in(2)
    sleep 0.125
  end
  
end




