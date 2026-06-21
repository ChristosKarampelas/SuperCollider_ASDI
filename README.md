Teardropish
Ο κώδικας δημιουργήθηκε βήμα-βήμα με στόχο να αποδώσει το ατμοσφαιρικό, hypnotic trip-hop vibe του «Teardrop» (Mezzanine, 1998) χωρίς φωνητικά: βαθύ sub-bass, χαρακτηριστικό plucked/harpsichord-like hook, subtle κρουστά, lush pads και airy layers. Δομή algorithmic composition σε SuperCollider.

1. Server setup
Ρυθμίστηκαν blockSize = 1024, hardwareBufferSize = 1024, memSize = 65536 και latency = 0.3 για σταθερή απόδοση και χαμηλή latency σε real-time playback. (επίσημο documentation: ServerOptions και συζητήσεις σε scsynth.org για buffer/latency).

2. SynthDefs 
Κάθε synth γράφτηκε μετά από ανάλυση του ήχου του κομματιού και προσαρμογή με UGens της SuperCollider:
	•	\bass: Δύο layered SinOsc (fundamental + 2nd harmonic) + HPF/LPF για καθαρό, βαθύ sub που δεν λασπώνει.
	•	\kick: XLine για pitch drop + SinOsc + λίγο bandpass noise.
	•	\dustHat: WhiteNoise + HPF + πολύ short Env.perc. Απαλό, dusty hi-hat.
	•	\wash: Detuned VarSaw (με array [0.996, 1.0, 1.004]) + sub-sine + FreeVerb.
	•	\glass (το πιο «Teardrop» στοιχείο): Pluck.ar με WhiteNoise exciter + CombC για extra resonance.
	•	\string: Multi-osc (Saw + Pulse) με SinOsc vibrato + λίγο BrownNoise + RLPF + FreeVerb. Προσομοιώνει layered strings με κίνηση.
	•	\air: PinkNoise + steep filtering + πολύ long Env.asr.

3. Patterns & δομή (blocks 5-6)
TempoClock στα 72 BPM (κοντά στο relaxed feel του original). Pdef(\piece) με Ppar για παράλληλα layers, Pseq/Pwrand/Pwhite για επαναλήψεις και οργανική παραλλαγή (τα hats παίζουν probabilistic για να μην ακούγονται μηχανικά).

4. Master bus (Ndef \mix)
LeakDC + LPF + Compander + Limiter στο τέλος. Ελεγχος δυναμικής και προστασία από clipping σε performances.

Πηγές & αναφορές (όλες πραγματικές)
	•	Επίσημη τεκμηρίωση SuperCollider: doc.sccode.org 
	•	scsynth.org thread για Pluck/Karplus-Strong: Why does my synth glitch at higher pitches? 
	•	r/supercollider (Reddit)
