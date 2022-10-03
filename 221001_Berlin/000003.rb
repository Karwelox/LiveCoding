#000003
#________________
#Chords 1: MIB DO- SOL SIB
#Chords 2: EB3 MINOR, BB3 MINOR7, C3 MINOR, D3 MAJOR

use_bpm 114  

#Lenght arp bars
num1 = 4 * 8
num2 = 4 * 4
num3 = 4 * 4
num4 = 4 * 4


num_times = [num1,num2,num3,num4]    #repeating time harmony
note = [:Eb3, :Bb3, :Ab3, :Fs3]
note_bass = [:Eb1, :Bb1, :Ab1, :Fs1]
note_high = [:Eb5, :Bb5, :Ab5, :Fs5]
modes = [:minor, :minor7, :minor, :major]
act_note = note[0]
act_mode = modes[0]
act_num = num_times[0]
synth_bass = :tb303
synth_high = :sine
synth_arp = :saw

sleep_time = 1   #def 0.5, min 0.25


snarePattern = "---x"

define :pattern do |pattern|
  return pattern.ring.tick == "x"
end


define :harmonyUpdate do
  if one_in(2)
    if one_in(2)
      note = [:Eb3, :B3, :Bb3, :Ab3]
      note_bass = [:Eb1, :B1, :Bb1, :Ab1]
      note_high = [:Eb5, :B5, :Bb5, :Ab5]
      modes = [:minor, :major, :minor7, :minor]
    else
      note = [:Eb3, :B3, :F3, :Bb3]
      note_bass = [:Eb1, :B1, :F1, :Bb1]
      note_high = [:Eb5, :B5, :F5, :Bb5]
      modes = [:minor, :major, '7' , :major]
    end
  else
    note = [:Eb3, :Bb3, :Ab3, :Fs3]
    note_bass = [:Eb1, :Bb1, :Ab1, :Fs1]
    note_high = [:Eb5, :Bb5, :Ab5, :Fs5]
    modes = [:minor, :minor7, :minor, :major]
  end
end


define :noteUpdate do
  act_note = note.tick(:note_tick)
  act_mode = modes.tick(:mode_tick)
  act_num = num_times.tick(:num_tick)
end

define :drumLoopUpdate do
  if one_in(2)
    snarePattern = "-------x---x--x-"
  else
    snarePattern = "-------x--------x"
  end
end



live_loop :mainArp do
  
  att1 = 0.05
  att2 = 0.1
  r1 = 0.01
  r2 =  0.1
  ampArp = 2.5  #start value 0.5
  
  stop
  use_synth synth_arp
  with_fx :bitcrusher, mix: 0.5 do
    with_fx :gverb, amp: 1, mix: 1 do
      with_fx :lpf, cutoff: range(20,70, step:10).shuffle.tick(:tickMainArp), amp: 0.5 do
        with_fx :echo, mix: 1, phase: 0.75, decay: 1 do
          
          
          act_num.times do
            play chord(act_note, act_mode, num_octaves:2).reverse.tick, attack: rrand(att1, att2), release: rrand(r1*3, r2*3), amp: rrand(0.5,1.25), pan:(range -1, 1, step: 0.01).mirror.tick
            sleep sleep_time
          end
          
          harmonyUpdate
          noteUpdate
          drumLoopUpdate
          
          
        end
      end
    end
  end
  
  
  
end



## BASSO ##

live_loop :bass_main, sync: :mainArp do
  stop
  amp_b = 6
  use_synth synth_bass
  with_fx :reverb, mix:0.7 do
    #with_fx :whammy, mix: 0.1 do
    play act_note-24, amp: amp_b , cutoff: (line 50, 70, steps:10).mirror.tick, release: act_num/2.5, attack:0.5, cutoff_attack: sleep_time*act_num/2, cutoff_release: sleep_time*act_num/2
    #end
  end
  
  sleep sleep_time*act_num
  
end


live_loop :high_notes, sync: :mainArp do
  
  stop
  ampl = 0.7
  co1 = 65
  co2 = 90
  
  use_synth synth_high
  
  with_fx :tremolo, mix: 0.7, phase: 0.5, depth: 3 do
    with_fx :echo, phase: 0.85, decay: 4   do
      with_fx :reverb, amp: 0.7 do
        play act_note+12, amp: ampl, cutoff: rrand(co1, co2), attack: 1.5, release: act_num/2, pitch: rrand(-0.25, 0.25)
        sleep sleep_time*act_num
      end
    end
  end
  
end




#KICK
live_loop :kick, sync: :mainArp  do
  stop
  #with_fx :bitcrusher, mix: 0.5, cutoff: 90 do
  sample :bd_haus, beat_stretch: 1, amp: 6, cutoff: 80 if pattern "x"# #"x---x" #"x"#
  #sample :bd_haus, beat_stretch: 1, amp: 1, rate: -1, cutoff: 80 if pattern "--x-"  #"x---x"
  sleep 1
  #end
  
end


#SNARE
live_loop :snareDaft, sync: :mainArp do
  stop
  with_fx :compressor, amp: 2 do
    with_fx :reverb, mix: 0.5 do
      sleep 1
      sample :sn_dolf, beat_stretch: rrand(1,2)
      if one_in(6)
        sleep 0.75
        sample :drum_snare_hard, beat_stretch: 2, rate: 1
        sleep 0.25
      else
        sleep 1
      end
      
    end
  end
end






live_loop :hat, sync: :mainArp do
  stop
  ampHat = 4
  
  if one_in(4)
    if one_in(2)
      5.times do
        sample :drum_cymbal_closed, beat_stretch: 0.1, amp: ampHat * rrand(0.5, 0.9)
        sleep 0.25
      end
      
    else
      8.times do
        sample :drum_cymbal_closed, beat_stretch: 0.1, amp: ampHat * rrand(0.5, 0.9)
        sample :elec_blup, start: 0, finish: 0.1 , beat_stretch: rrand(0.5, 1.5), amp: ampHat/2 if one_in(4)
        sleep 0.125
      end
      
      
    end
  else
    3.times do
      sleep 0.25
      sample :drum_cymbal_closed, beat_stretch: 0.1, amp: ampHat * rrand(0.5, 0.9)
    end
    sleep 0.25
  end
end



#GLITCHY
live_loop :glitchy, sync: :mainArp do
  
  stop
  ampGeneral = 6
  with_fx :krush, decay: 2, amp: 1, mix: rrand(0.25,0.75) do
    with_fx :gverb, mix: rrand(0.2, 0.5), mix: 0.5, amp: 0.5 do
      with_fx :echo, mix: choose([0.5, 0.75, 1]), phase: choose([0.5, 0.75, 1]) do
        sleep 0.75
        sample :glitch_perc5, beat_stretch: rrand(0.5, 0.8), amp: ampGeneral * rrand(0.5, 0.9)
        sleep 0.25
        sample :guit_em9, beat_stretch: 4, onset: pick, amp: ampGeneral * rrand(0.5, 0.9)
        sleep 0.25
        #sample :glitch_perc3, rate: choose([-1, -0.5, -0.75]), amp: ampGeneral * rrand(0.5, 0.9)
        sleep 0.25
        sample :glitch_perc2, rate: rrand(0.1, 1), amp: ampGeneral * rrand(0.5, 0.9)
        sleep 0.5
        sample :glitch_perc4, beat_stretch: rrand(0.5, 1), amp: ampGeneral * rrand(0.5, 0.9)
        sleep 0.25
        #sample :guit_em9, beat_stretch: 3, onset: pick, release: 0.1, amp: ampGeneral * rrand(0.5, 0.9)
        sleep 0.75
        
        sample :guit_harmonics, beat_stretch: 4.5, onset: pick, amp: ampGeneral+ rrand(0.5, 0.9), release: 0.5
        
        sleep 0.25
        sample :guit_em9, beat_stretch: 3.75, onset: pick, amp: ampGeneral+ rrand(0.5, 0.9), release: 0.1
        sleep 0.75
        sample :loop_industrial, onset: pick, rate: -1, release:0.1, amp: ampGeneral+ rrand(0.5, 0.9)
      end
    end
  end
  
end










