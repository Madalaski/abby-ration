from PIL import Image

new_filename = "generated_screen_uv.png"

new_img = Image.new("RGB", (2048, 2048))

for x in range(new_img.width):
    for y in range(new_img.height):
        new_img.putpixel((x, y), (int(255*(x/2048)), int((255*y/2048)), 0))

new_img.save(new_filename)
new_img.show()
print("done!")
