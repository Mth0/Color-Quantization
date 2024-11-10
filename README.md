### Para falantes de português, o documento "quantizacao_cores.pdf" detalha melhor o algoritmo e resultados!

# Resume

I discute about the color quantization problem and try to solve it, approximately, using the GRASP meta-heuristics. The .ipynb file has the implementation in Julia and some examples of its use. The implementation is in a distributed version. It seems the algorithm got really faster and it helped to test it in some larger images.

# Color quantization

The one of the mostly image format used in computers and other devices is the RGB format. In this format there are three channels which values can vary between 0 and 255. The pixels, therefore, are represented by three values, one for each channel. So we have $256^{3}$ possible colors! That's a lot more than the number of colors a human can recognize. In fact, this huge number of possible colors can enlarge the image file size. So what if we delimit the number of colors of our image? Is it possible to reduce drastically this number and maintain a good image quality? Yes!

Color quantization looks to solve this problem: To find a good color palette that reduce the number of colors of the image and preserve its quality. There are a lot of ways to define this problem more precisely and a lot of algorithms to solve it. I'll define it in a specific way, but remind that it's not the unique way to do that. First let's remind that in the RGB format images with $m$ pixels by $n$ pixels can be represented as $3$ matrices with $m \times n$ dimension, one matrix for each channel containing the values of the pixels in that channel.

So let $I$ be the $3 \times m \times n$ matrix representation of the original image. I want $\hat{I}$ such that it minimizes

$$f(\hat{I}) = |I - \hat{I}|_{F}^{2}$$

Where $|\cdot|_{F}$ is the Frobenius norm with definition

$$|A_{m \times n \times o}|_{F}^{2} = \sum\_{i=1}^{m}\sum\_{j=1}^{n}\sum\_{k=1}^{o}a\_{ijk}^{2}$$

Frobenius norm tries to generalize the vector norm. So the intuition is that we want a matrix $\hat{I}$ that's "close" to the $I$ matrix. Note that the "palette" doesn't appear hear. But we can make it happen. Let's define the function that recolor the image with some palette $P$ of length $k$ as

$$p_{k}(I, P)\_{:ij} = arg\min_{l}\|I_{:ij} - P_{l}\|$$

That is, the color in the palette that's close to the pixel will be the new color of that pixel. So we have $f$ in function of $P$ as

$$f(P)=\|I - p_{k}(I, P)\|_{F}^{2}$$

And that's what we're going to minimize. Unfortunely, this is a NP-Complete problem. If we have $256^{3}$ possible colors, how many palettes of length $k$ can we have? A lot of them! More precisely, we have

$${256^3 \choose k} = \frac{(256^{3})!}{k!(256^3 - k)!}$$

Choices. So, to define what palette is optimum is impractical. To solve this, I'm going to use the GRASP meta-heuristic.

# Results

I tested this implementation in some images. And show the results here.

- The first one is an image of two cats. The first is the original one and the second the one from GRASP with 64 colors only.
- The second is an image from Naruto's Manga. The first image is the original one and the second the one from GRASP with 64 colors only.
- The third is an image from Pokémon Yellow game. The interesting fact is the this game was released for Game Boy Color, a portable console that only supported 546 simultaneous colors in the screen. So what if we try to quantize this imagem with only 56 colors? The first image is the original one and the second the one from GRASP with only 56 colors.

## Cats image

<div align="center">
  <image src="https://github.com/user-attachments/assets/00285c44-7c2e-472e-b15f-32fe4a889dce">
</div>

<div align="center">
  <image src="https://github.com/user-attachments/assets/adc9d88a-8727-4ae8-ad8f-e3a974fb778c">
</div>

## Naruto image

<div align="center">
  <image src="https://github.com/user-attachments/assets/134f51e6-dec8-44a9-84d7-69cce350e90f">
</div>

<div align="center">
  <image src="https://github.com/user-attachments/assets/14ff162f-2115-47b6-b73a-c507c31f908e">
</div>

## Pokémon Yellow image

<div align="center">
  <image src="https://github.com/user-attachments/assets/8321dda8-2ba1-45a4-af4e-65f7ff3b510d">
</div>

<div align="center">
  <image src="https://github.com/user-attachments/assets/cc9e233e-296e-473b-937e-b631cd634ccb">
</div>

# Some conclusions

GRASP seems to work fine, but the greedy search and local search are **really** expansive and probably I'll try to fasten it in the future.
