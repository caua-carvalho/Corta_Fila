    const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  app.use(
    '/api',                   // prefixo das suas chamadas
    createProxyMiddleware({
      target: 'http://localhost:8000/',
      changeOrigin: true,     // ajusta o header Host
    })
  );
};