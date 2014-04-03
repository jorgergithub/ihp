function toPNG(image) {
  image.onerror = null;
  image.src = image.src.replace(/\.svg$/, ".png");
}
