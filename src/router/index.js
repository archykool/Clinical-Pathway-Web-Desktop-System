import VueRouter from 'vue-router';
import Vue from 'vue';

Vue.use(VueRouter);

const routes = [{
    path: '/',
    name: 'App',
    redirect: '/login',
    component: () => import('@/App'),
    children: [{
        path: 'login',
        name: 'Login',
        component: () => import('@/views/login/Login')
    }, {
        path: 'auth',
        name: 'Layout',
        redirect: '/auth/home',
        component: () => import('@/views/layout/Layout'),
        children: [{
            path: 'home',
            name: 'Home',
            component: () => import('@/views/home/Home')
        }, {
            path: 'change',
            name: 'Change',
            component: () => import('@/views/change/Change')
        }, {
            path: 'pathSet',
            name: 'PathSet',
            component: () => import('@/views/pathSet/PathSet')
        }, {
            path: 'pathSetDetail',
            name: 'PathSetDetail',
            component: () => import('@/views/pathSet/PathDetail')
        }, {
            path: 'illness',
            name: 'Illness',
            component: () => import('@/views/illness/Illness')
        },  {
            path: 'illnessDetail',
            name: 'IllnessDetail',
            component: () => import('@/views/illness/IllnessDetail')
        }]
    }]
}];

export default new VueRouter({
    routes
});