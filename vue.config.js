/**
 * 跨域及生产环境等配置
 * @type {{devServer: {proxy: {"/": {changeOrigin: boolean, secure: boolean, target: string}}}, css: {loaderOptions: {less: {javascriptEnabled: boolean}}}, publicPath: string}}
 */
module.exports = {
    // cli3 代理是从指定的target后面开始匹配的，不是任意位置；配置pathRewrite可以做替换
    devServer: {
        proxy: {
            '/': {
                target: 'http://47.102.212.240:100/server/public/index.php/index',
                changeOrigin: true,
                secure: false,
                /*pathRewrite: { }*/
            }
        }
    },
    css: {
        loaderOptions: { // 向 CSS 相关的 loader 传递选项
            less: {
                javascriptEnabled: true
            }
        }
    },
    publicPath: process.env.NODE_ENV === 'production'
        ? './'
        : '/'
};