# Remove curtain spill from glitch frames of a VP9-alpha matte.
# new_alpha = min(alpha, dilate(alpha_of_nearest_clean_frame, R)) inside the spill zone (left strip).
import subprocess, sys, numpy as np
from scipy.ndimage import grey_dilation
src, dst = sys.argv[1], sys.argv[2]
W, H = 1080, 1920
raw = subprocess.run(["ffmpeg","-v","error","-c:v","libvpx-vp9","-i",src,"-f","rawvideo","-pix_fmt","rgba","-"],capture_output=True).stdout
fr = np.frombuffer(raw, np.uint8).reshape(-1, H, W, 4).copy()
n = len(fr)
glitch = [i for i in range(n) if (fr[i][0:900, 0:320, 3] > 40).mean() > 0.0005]
clean = [i for i in range(n) if i not in glitch]
print("frames", n, "glitch", glitch)
zone = np.zeros((H, W), bool); zone[:, :520] = True   # spill zone: the curtain strip on the left
for i in glitch:
    j = min(clean, key=lambda c: abs(c - i))
    ref = grey_dilation(fr[j][..., 3], size=(25, 25))
    a = fr[i][..., 3]
    fr[i][..., 3] = np.where(zone, np.minimum(a, ref), a)
# every frame: drop faint alpha (< 48) in the spill zone. The outline chain amplifies faint alpha into solid white.
for i in range(n):
    a = fr[i][..., 3]
    fr[i][..., 3] = np.where(zone & (a < 48), 0, a)
enc = subprocess.Popen(["ffmpeg","-v","error","-y","-f","rawvideo","-pix_fmt","rgba","-s",f"{W}x{H}","-r","30","-i","-",
    "-c:v","libvpx-vp9","-pix_fmt","yuva420p","-b:v","0","-crf","20","-g","30","-keyint_min","30","-row-mt","1","-deadline","good","-cpu-used","2",dst],stdin=subprocess.PIPE)
enc.stdin.write(fr.tobytes()); enc.stdin.close(); enc.wait()
print("done", enc.returncode)
