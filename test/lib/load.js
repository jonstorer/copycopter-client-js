requirejs.config({
  baseUrl: '../..',
  packages: ['copycopter-client-js']
});

// Start the main app logic.
requirejs(['copycopter-client-js'], function (CopyCopter) {
  console.log(CopyCopter);
  window.CopyCopter = CopyCopter
});
