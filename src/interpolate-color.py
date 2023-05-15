import math

# i made this to quickly convert the grey color gradient to match ayu colors
# please don't doxx me for my obnoxious python code k thx

gradient = [0xFA,0xF2,0xEE,0xDD,0xCC,0xBF,0xA0,0x9E,0x86,0x72,0x55,0x46,0x3C,0x2C,0x24,0x21,0x12,0x0F,0x03]
gradient.reverse() # too lazy to reverse the thing

gradient = [x/255 for x in gradient] # normalize

# interpolate between two colors
def interpolate_color(c1,c2,t):
    r1,g1,b1 = c1
    r2,g2,b2 = c2
    r = r1 + (r2-r1)*t
    g = g1 + (g2-g1)*t
    b = b1 + (b2-b1)*t
    return (r,g,b)

# get the perceived lightness of a color
def get_lightness(c):
    r,g,b = c 
    return (0.2126*r + 0.7152*g + 0.0722*b)

color_start = (0x1f, 0x24, 0x30) # vscode background color
color_end = (0xfc, 0xfc, 0xfc) # some random white color

color_start = tuple(x/255 for x in color_start) # normalize
color_end = tuple(x/255 for x in color_end)

start_index = 5 # index 5 is used for the background
end_index = 18 # index 18 is the brightest color

start_gradient = gradient[start_index]
end_gradient = gradient[end_index]

# get the darkest and brightest colors by extrapolating
color_min = tuple(gradient[0] * x/start_gradient for x in color_start)
color_max = tuple(gradient[-1] * x/end_gradient for x in color_end)

for i in range(len(gradient)-1, -1, -1):
    t = gradient[i]

    if i < start_index: # black - start
        t = (t-gradient[0])/(start_gradient-gradient[0])
        color = interpolate_color(color_min, color_start, t)
    elif i > end_index: # end - white
        t = (t-end_gradient)/(gradient[-1]-end_gradient)
        color = interpolate_color(color_end, color_max, t)
    else: # start - end
        t = (t-start_gradient)/(end_gradient-start_gradient)
        color = interpolate_color(color_start, color_end, t)

    # i hate python (no reason provided)
    color = tuple(int(x*255) for x in color)
    color = color[0] << 16 | color[1] << 8 | color[2]    
    
    print(f"{hex(color)}")
