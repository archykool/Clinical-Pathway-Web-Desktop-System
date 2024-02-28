/**
 * Vue主程序依赖初始化
 */
import Vue from 'vue';
import App from './App.vue';
import router from '@/router';
import '@/public/css/reset.css';
import '@/plugins/element.js';
import '@/plugins/antd.js';
//引入eacharts
import echarts from 'echarts';
//引入nprogress
import NProgress from 'nprogress'
import 'nprogress/nprogress.css' //这个样式必须引入
import '@/public/css/antd.less';


Vue.config.productionTip = false;
Vue.prototype.$echarts = echarts;

/*NProgress.configure({
  easing: 'ease',  // 动画方式
  speed: 500,  // 递增进度条的速度
  showSpinner: false, // 是否显示加载ico
  trickleSpeed: 200, // 自动递增间隔
  minimum: 0.3 // 初始化时的最小百分比
});*/
/*// 简单配置
NProgress.inc(0.2);
NProgress.configure({ easing: 'ease', speed: 500, showSpinner: false })*/


router.beforeEach((to,from,next) => {
  NProgress.start();
  next()
});

router.afterEach(() => {
  NProgress.done();
});

new Vue({
  render: h => h(App),
  router,
}).$mount('#app');
