<template>
  <div class="left-nav">
    <el-radio-group v-model="isCollapse" style="margin-bottom: 20px;" >
      <el-radio-button :label="collapse" v-col><a-icon type="menu-fold" class="collapse" @click="collapse = !collapse"/></el-radio-button>
    </el-radio-group>
    <el-menu :default-active="$route.path" class="el-menu-vertical-demo" @open="handleOpen" @close="handleClose" :collapse="isCollapse">
      <el-submenu index="2">
        <template slot="title">
          <i class="el-icon-s-home"></i>
          <span slot="title">统计分析</span>
        </template>
        <el-menu-item-group>
          <router-link to="/auth/home"><el-menu-item index="/auth/home">路径使用率</el-menu-item></router-link>
        </el-menu-item-group>
        <el-menu-item-group>
          <router-link to="/auth/change"><el-menu-item index="/auth/change">路径变异率</el-menu-item></router-link>
        </el-menu-item-group>
      </el-submenu>
      <!--<el-submenu index="5">
        <template slot="title">
          <i class="el-icon-location"></i>
          <span slot="title">号码管理</span>
        </template>
        <el-menu-item-group>
          <router-link to="/admin/produce"><el-menu-item index="5-1">订单列表</el-menu-item></router-link>
        </el-menu-item-group>
        <el-menu-item-group>
          <router-link to="/admin/produce"><el-menu-item index="5-2">我的订单</el-menu-item></router-link>
        </el-menu-item-group>
      </el-submenu>-->
      <!--<router-link to="/auth/phone">
        <el-menu-item index="/auth/phone">
          <i class="el-icon-phone-outline"></i>
          <span slot="title">号码管理</span>
        </el-menu-item>
      </router-link>-->
      <router-link to="/auth/pathSet">
        <el-menu-item index="/auth/pathSet">
          <i class="el-icon-data-board"></i>
          <span slot="title">路径配置模块</span>
        </el-menu-item>
      </router-link>
      <router-link to="/auth/illness">
        <el-menu-item index="/auth/illness">
          <i class="el-icon-collection-tag"></i>
          <span slot="title">患者路径管理</span>
        </el-menu-item>
      </router-link>
     <!-- <el-submenu index="2">
        <template slot="title">
          <i class="el-icon-data-analysis"></i>
          <span slot="title">元数据管理</span>
        </template>
        <el-menu-item-group>
          <router-link to="/auth/schema"><el-menu-item index="/auth/schema">表管理</el-menu-item></router-link>
        </el-menu-item-group>
        <el-menu-item-group>
          <router-link to="/auth/words"><el-menu-item index="/auth/words">表字段管理</el-menu-item></router-link>
        </el-menu-item-group>
      </el-submenu>-->
      <!--<el-submenu index="3">
        <template slot="title">
          <i class="el-icon-attract"></i>
          <span slot="title">接口管理</span>
        </template>
        &lt;!&ndash;<el-menu-item-group>
          <router-link to="/auth/interface"><el-menu-item index="/auth/interface">接口对接</el-menu-item></router-link>
        </el-menu-item-group>&ndash;&gt;
        <el-menu-item-group>
          <router-link to="/auth/interfaceKey"><el-menu-item index="/auth/interfaceKey">密钥管理</el-menu-item></router-link>
        </el-menu-item-group>
        <el-menu-item-group>
          <router-link to="/auth/interfaceData"><el-menu-item index="/auth/interfaceData">数据模板管理</el-menu-item></router-link>
        </el-menu-item-group>
      </el-submenu>
      <router-link to="/auth/file">
        <el-menu-item index="/auth/file">
          <i class="el-icon-upload2"></i>
          <span slot="title">文件管理</span>
        </el-menu-item>
      </router-link>
      <router-link to="/auth/authority">
        <el-menu-item index="/auth/authority">
          <i class="el-icon-setting"></i>
          <span slot="title">权限管理</span>
        </el-menu-item>
      </router-link>-->
    </el-menu>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        isCollapse: true,
        collapse:true
      };
    },
    methods: {
      handleOpen(key, keyPath) {
        console.log(key, keyPath);
      },
      handleClose(key, keyPath) {
        console.log(key, keyPath);
      }
    },
    computed: {

    },
    directives:{
      col:{
        inserted(el){
          el.addEventListener('click', function (){
            this.collapse=false;
          })
        }
      }
    },
    mounted() {
      let inner=document.querySelector('.el-radio-button__inner');
      inner.classList.add('collapse_active');
    }
  }
</script>

<style  scoped>
</style>
<style lang="less">
  .left-nav{
    .el-menu-vertical-demo:not(.el-menu--collapse) {
      width: 200px;
      min-height: 400px;
    }
    .collapse{
      color: black;
      font-size: 25px;
      transition: .3s all;
      &:hover{
        color: #54B2FE;
      }
    }
    .collapse_active{
      background-color: transparent !important;
      border: none;
    }
    .el-menu-item.is-active{
      background: #54B2FE;
      color: #ffffff;
    }
    .el-radio-button{
      position: absolute;
      top: 17px;
      left: 215px;
    }
    .el-radio-button__orig-radio:checked+.el-radio-button__inner{
      border: none;
    }
    .el-menu-item [class^=el-icon-], .el-submenu [class^=el-icon-]{
      margin-bottom: 3px;
    }
  }
</style>
