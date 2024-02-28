<template>
    <div class="admin">
        <Header/>
            <div class="admin-side">
                <div class="admin-left">
                    <LeftBar/>
                </div>
                <div class="admin-content">
                    <transition name="el-fade-in" mode="out-in">
                        <router-view/>
                    </transition>
                </div>
            </div>
    </div>
</template>

<script>
    import Header from '@/components/header';
    import LeftBar from '@/components/leftBar';
/*    import storeUntil from "@/untils/storeUntil";*/

    export default {
        name: "Layout",
        data(){
            return {
                userMes:{},
                value:'',
            }
        },
        methods:{
        },
        computed: {

        },
        mounted(){
            document.querySelector('.admin-content').style.height=document.documentElement.clientHeight - 68 + 'px';

        },
        components:{
            Header,
            LeftBar
        }
    }
</script>

<style lang="less">
    .admin{
        min-width: 1600px;
        position: relative;
        .admin-side{
            display: flex;
            flex-direction: row;
        }
        .admin-left{
            text-align: left;
            .left-nav{
                .el-radio-button{
                    left: 194px;
                }
            }
        }
        .admin-content{
            flex: 1;
            background: #F4F6F9;
            padding: 20px;
            overflow-y: scroll;
            overflow-x: hidden;
        }
    }
</style>
