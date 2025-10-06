try:
    import pygame
except ModuleNotFoundError:
    pass
import sys


def beep():
# Parameters for an Apple II–style beep
	frequency = 1024  # ~1 kHz
	duration = 0.1    # 100 ms
	sample_rate = 44100

# Generate square wave (Apple II used digital toggling)
	t = np.linspace(0, duration, int(sample_rate * duration), False)
	wave = 0.5 * np.sign(np.sin(2 * np.pi * frequency * t))

# Convert to 16-bit PCM
	audio = (wave * 32767).astype(np.int16)

# Play it
	play_obj = sa.play_buffer(audio, 1, 2, sample_rate)
	play_obj.wait_done()
