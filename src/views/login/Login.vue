<template>
       <div id="login">
           <div class="login-box">
               <div class="right-box">
                   <h1>用户登录</h1>
                   <a-form layout="horizontal" :form="form">
                       <a-form-item  :formItemLayout="formItemLayout">
                           <a-input type="text"
                                    v-decorator="[
                                              'user',
                                              { rules: [{ required: true, message: '请输入用户名!' }] }
                                            ]"
                                    placeholder="请输入用户名">
                               <a-icon
                                       slot="prefix"
                                       type="user"
                                       style="color: rgba(0,0,0,.25)"
                               />
                           </a-input>
                       </a-form-item>
                       <a-form-item  :formItemLayout="formItemLayout">
                           <a-input type="password"
                                    v-decorator="[
                                              'pass',
                                              { rules: [{ required: true, message: '请输入密码!' }] }
                                            ]"
                                    placeholder="请输入密码">
                               <a-icon
                                       slot="prefix"
                                       type="lock"
                                       style="color: rgba(0,0,0,.25)"
                               />
                           </a-input>
                       </a-form-item>
                       <a-form-item  :formItemLayout="formItemLayout">
                           <a-input type="text"
                                    placeholder="请输入验证码"
                                    v-decorator="[
                                              'code',
                                              { rules: [{ required: true, message: '请输入验证码!' }] }
                                            ]">
                               <a-icon
                                       slot="prefix"
                                       type="safety-certificate"
                                       style="color: rgba(0,0,0,.25)"
                               />
                           </a-input>
                           <div id="verify" @click="refreshCode">
                               <img :src="validateImg" alt="验证码" style="width: 100%; height: 100%;">
                           </div>
                       </a-form-item>
                       <a-form-item  :formItemLayout="formItemLayout">
                           <a-checkbox>记住此次登录信息</a-checkbox>
                           <a-button type="primary" htmlType="submit" class="login-form-button" :loading="loading" @click="login">
                               登录
                           </a-button>
                       </a-form-item>
                   </a-form>
               </div>
           </div>
       </div>
</template>

<script>

    import {reqLogin} from "../../api/main";
    import storeUntil from "../../untils/storeUntil";

    export default {
        name: "Login",
        data() {
            return {
                loading: false,
                form: this.$form.createForm(this),
                formItemLayout: {
                    labelCol:{ span: 8 },
                    wrapperCol:{ span: 15 },
                },
                validateImg: '/Login/productCode',
            }
        },
        methods: {
            refreshCode () {
                const num = Math.ceil(Math.random() * 10);

                this.validateImg = '/Login/productCode?' + num;
            },
            login () {
                this.form.validateFields( async (err, values) => {
                    if (err){
                        return false;
                    }
                    this.loading = true;

                    const result = await reqLogin(values);

                    const { code, message, messageBody } = result.data;

                    if (code === 0){
                        this.$message.success(message);
                        storeUntil.setInfo({
                            userId: messageBody.userID,
                            userName: messageBody.userName,
                            userType: messageBody.userType
                        });
                        this.$router.push('/auth/home');
                    } else {
                        this.$message.error(message);
                        this.refreshCode();
                    }
                    this.loading = false;
                });
            }
        },
        mounted() {
        }
    }
</script>

<style lang="less">
    #login{
        background: url("../../public/images/bg.png") no-repeat center center;
        background-size: 100% 100%;
        overflow: hidden;
        overflow-x: auto;
        min-width: 1400px;
        .login-box{
            width: 1403px;
            height: 650px;
            margin: 150px auto;
            background: url("../../public/images/login.png") no-repeat center center;
            background-size: 100% 100%;
            display: flex;
            flex-direction: row;
            justify-content: flex-end;
            .right-box{
                display: flex;
                flex-direction: column;
                align-items: center;
                width: 660px;
                height: 580px;
                text-align: center;
                .ant-form{
                    width: 400px;
                    text-align: left;
                    padding-left: 50px;
                    padding-top: 20px;
                }
                h1{
                    color: #2882fe;
                    font-weight: 500;
                    padding-top: 100px;
                    font-size: 30px;
                }
                .ant-input{
                    width: 300px;
                    height: 40px;
                }
                span{
                    color:#B5B5B5;
                }
                .ant-btn{
                    width: 300px;
                    height: 40px;
                    margin-top: 10px;
                    span{
                        font-size: 17px;
                        color: white;
                    }
                }
                .ant-form-item{
                    input{
                        padding-left: 40px;
                    }
                }
                .ant-form-item:first-child{
                    margin-top: 25px;
                }
                .ant-form-item:nth-child(2){
                    margin-bottom: 25px;
                }
                .ant-form-item:nth-child(3){
                    margin-top: 0;
                    margin-bottom: 10px;
                    input{
                        width: 170px;
                    }
                }
                #verify{
                    width: 100px;
                    height: 40px;
                    position: absolute;
                    right: 70px;
                    top: -13px;
                    cursor: pointer;
                }
                .register{
                    span{
                        color: #1C93FF;
                        cursor: pointer;
                        margin-left: 5px;
                        &:hover{
                            text-decoration: underline;
                        }
                    }
                }
            }
        }
    }
</style>