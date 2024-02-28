<template>
    <div id="detail-form">
        <Title :title="'路径模板详情'"/>
        <div class="container">
            <div class="conform-words">
                <div class="add-title">
                    <i class="title-icon"/>
                    路径模板细节
                </div>
                <a-button type="link" icon="arrow-left" @click="$router.go(-1)">返回路径配置模块</a-button>
            </div>
            <div class="description">
                <a-descriptions layout="vertical" bordered>
                    <a-descriptions-item label="路径名称">{{detailInfo.pathName || '-'}}</a-descriptions-item>
                    <a-descriptions-item label="疾病编码">{{detailInfo.pathCode || '-'}}</a-descriptions-item>
                    <a-descriptions-item label="入院科室">{{detailInfo.pathDept || '-'}}</a-descriptions-item>
                    <a-descriptions-item label="入径条件">{{detailInfo.pathReq || '-'}}</a-descriptions-item>
                    <a-descriptions-item label="标准住院日">{{detailInfo.pathSlos || '-'}}</a-descriptions-item>
                    <a-descriptions-item label="创建人" :span="3">{{detailInfo.pathCrtstaff || '-'}}</a-descriptions-item>
                </a-descriptions>
            </div>
           <div class="box-container">
               <div class="conform-words" style="margin-top: 30px;">
                   <div class="add-title">
                       <i class="title-icon"/>
                       环节定义
                   </div>
               </div>
               <div class="table-area">
                   <a-button icon="plus" @click="addNewPath">新增环节</a-button>
                   <el-table
                           :data="tableData"
                           border
                           class="myTable"
                           style="max-height: 700px; margin-top: 20px;text-align: center;">
                       <el-table-column
                               prop="pathsegDa"
                               label="天数"
                               >
                           <template slot-scope="scope">
                               <span>{{'第' + scope.row.pathsegDay + '天'}}</span>
                           </template>
                       </el-table-column>
                       <el-table-column
                               label="操作"
                               width="300">
                           <template slot-scope="scope">
                               <a-button icon="search" type="link" style="margin-right: 20px;" @click="showContent(scope.row)"/>
                               <a-button icon="edit" type="link" style="margin-right: 20px;" @click="editPath(scope.row)"/>
                               <a-button icon="delete" type="link" style="color: red;" @click="deletePath(scope.row)"/>
                           </template>
                       </el-table-column>
                   </el-table>
               </div>
           </div>
            <div class="box-container">
                <div class="conform-words" style="margin-top: 30px;">
                    <div class="add-title">
                        <i class="title-icon"/>
                        诊疗内容
                    </div>
                </div>
                <div class="table-area">
                    <a-button icon="plus" @click="addNewContent">新增内容</a-button>
                    <el-table
                            :data="tableData1"
                            border
                            class="myTable"
                            style="max-height: 700px; margin-top: 20px;text-align: center;">
                        <el-table-column
                                prop="itemCat"
                                label="诊疗类别名称"
                        >
                        </el-table-column>
                        <el-table-column
                                prop="itemName"
                                label="项目名称"
                        >
                        </el-table-column>
                        <el-table-column
                                label="操作"
                                width="300">
                            <template slot-scope="scope">
                                <a-button icon="edit" type="link" style="margin-right: 20px;" @click="editNewContent(scope.row)"/>
                                <a-button icon="delete" type="link" style="color: red;" @click="deleteContent(scope.row)"/>
                            </template>
                        </el-table-column>
                    </el-table>
                </div>
            </div>
        </div>
        <a-modal :title="modalTitle"
                 v-model="visible"
                 @ok="handleOk"
                 :class="['common-modal', 'tagGroup-modal']"
                 :destroyOnClose="true"
                 :keyboard="true"
                 :maskClosable="false"
                 :okText="'确认'"
                 :cancelText="'取消'"
                 :confirmLoading="confirmLoading">
            <div class="add-tag-group" v-if="!showHeader">
                <a-form :form="form">
                    <a-col :span="24">
                        <a-form-item label="天数"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input-number v-decorator="[
                                             'pathsegDay',
                                             {   initialValue: editInfo.pathsegDay || undefined,
                                                 rules: [
                                                 {   required: true, message: '请选择天数!' }] }
                                                ]"
                                     placeholder="请选择天数">
                            </a-input-number>
                        </a-form-item>
                    </a-col>
                </a-form>
            </div>
            <div class="add-tag-group" v-if="showHeader">
                <a-form :form="form">
                    <a-col :span="24">
                        <a-form-item label="诊疗类别名称"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-select
                                    v-decorator="[
                                                              'itemCat',
                                                              {    initialValue: editInfo.itemCat || undefined,
                                                                   rules: [
                                                                             {   required: true, message: '请选择诊疗类别名称!' }]
                                                              }
                                                            ]"
                                    placeholder="请选择诊疗类别名称"
                            >
                                <a-select-option  v-for="item in selectValue" :value="item.name" :key="item.id">
                                    {{item.name}}
                                </a-select-option>
                            </a-select>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="项目名称"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'itemName',
                                             {   initialValue: editInfo.itemName || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入项目名称!' }] }
                                                ]"
                                            placeholder="请输入项目名称">
                            </a-input>
                        </a-form-item>
                    </a-col>
                </a-form>
            </div>
        </a-modal>
    </div>
</template>

<script type="text/jsx">
    import Title from '@/components/contentTitle';
    import { Modal } from "ant-design-vue";
    import {
        reqAddDay, reqAddTreatment,
        reqContentByDay, reqDeleteDay,
        reqDeleteTreatment, reqPathDetailList,
        reqUpdateDay, reqUpdateTreatment
    } from "../../api/main";

    export default {
        name: "PathDetail",
        data () {
            return {
                confirmLoading: false,
                form: this.$form.createForm(this),
                detailInfo: {},
                visible: false,
                selectValue: [{
                    id: 1,
                    name: '主要诊疗工作'
                }, {
                    id: 2,
                    name: '长期医嘱'
                }, {
                    id: 3,
                    name: '临时医嘱'
                }, {
                    id: 4,
                    name: '主要工作护理'
                }],
                editInfo: {},
                pathDayId: '',
                modalTitle: '新增环节',
                showHeader: false,
                tableData: [],
                tableData1: [],
                formItemLayout: {
                    labelCol: { span: 7 },
                    wrapperCol: { span: 14 }
                },
            }
        },
        methods: {
            async getDetailList () {
                const result = await reqPathDetailList({
                    pathID: this.$route.query.pathID
                });

                const { code, message ,messageBody } = result.data;

                if (code === 0){
                    this.detailInfo = messageBody.title;
                    this.tableData = messageBody.content;
                } else {
                    this.$message.error(message);
                }
            },
            showContent (day) {
              this.pathDayId = day.pathsegID;
              this.getContent();
            },
            async getContent () {
                const result = await reqContentByDay({
                    pathsegID: this.pathDayId
                });

                const { code, message, messageBody } = result.data;

                if (code === 0){
                    this.tableData1 = messageBody;
                } else {
                    this.$message.error(message);
                }
            },
            confirm () {

            },
            handleOk () {
                this.form.validateFields(async (err, values) => {
                   if (err){
                    return false;
                   }

                   this.confirmLoading = true;

                   if (!this.showHeader){
                     if (!this.editInfo.pathsegID){
                         const result = await reqAddDay({
                             pathID: this.$route.query.pathID,
                             ...values
                         });

                         const { code, message } = result.data;

                         code === 0 && this.$message.success(message) && this.getDetailList();
                         code !== 0 && this.$message.error(message);

                     } else {
                         const result = await reqUpdateDay({
                             pathsegID: this.editInfo.pathsegID,
                             ...values
                         });

                         const { code, message } = result.data;

                         code === 0 && this.$message.success(message) && this.getDetailList();
                         code !== 0 && this.$message.error(message);

                     }
                       this.confirmLoading = false;
                       this.visible = false;
                   } else {
                       if (!this.editInfo.itemID){
                           const result = await reqAddTreatment({
                               pathsegID: this.pathDayId,
                               ...values
                           });

                           const { code, message } = result.data;

                           code === 0 && this.$message.success(message) && this.getContent();
                           code !== 0 && this.$message.error(message);

                       } else {
                           values.itemID = this.editInfo.itemID;
                           const result = await reqUpdateTreatment({
                               ...values
                           });

                           const { code, message } = result.data;

                           code === 0 && this.$message.success(message) && this.getContent();
                           code !== 0 && this.$message.error(message);

                       }
                       this.confirmLoading = false;
                       this.visible = false;
                   }
                });
            },
            addNewPath () {
                this.editInfo = {};
                this.modalTitle = "新增环节";
                this.showHeader = false;
                this.visible = true;
            },
            editPath (day) {
                this.modalTitle = '修改环节';
                this.showHeader = false;
                this.editInfo = day;
                this.visible = true;
            },
            addNewContent () {
                this.editInfo = {};
                this.showHeader = true;
                this.modalTitle = "新增内容";
                this.visible = true;
            },
            editNewContent (content) {
                this.editInfo = content;
                this.showHeader = true;
                this.modalTitle = "修改内容";
                this.visible = true;
            },
            deletePath (day) {
                Modal.confirm({
                    title: '删除环节',
                    content: '确定要删除该环节吗?',
                    okText: '确认',
                    cancelText: '取消',
                    onOk: async () => {
                        const result = await reqDeleteDay({
                            pathsegID: day.pathsegID,
                        });

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getDetailList();
                        code !== 0 && this.$message.error(message);
                    }
                })
            },
            deleteContent (content) {
                Modal.confirm({
                    title: '删除内容',
                    content: '确定要删除该内容吗?',
                    okText: '确认',
                    cancelText: '取消',
                    onOk: async () => {
                        const result = await reqDeleteTreatment({
                            itemID: content.itemID,
                        });

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getContent();
                        code !== 0 && this.$message.error(message);
                    }
                })
            }

        },
        filters: {

        },
        components: {
            Title
        },
        mounted() {
            this.getDetailList();
        }
    }
</script>

<style lang="less">
    .add-tag-group{
        .ant-input{
            background: #F7F9FA !important;
        }
        .ant-input:focus{
            background: #ffffff !important;
        }
        .ant-select-selection--single{
            background: #F7F9FA !important;
        }
    }
    .tagGroup-modal{
        .ant-btn{
            margin-top: 20px;
        }
        .ant-calendar-picker{
            width: 100% !important;
        }
        .ant-input-number{
            width: 220px;
        }
    }
    .personal-modal{
        .ant-btn{
            &:nth-child(1){
                display: none;
            }
        }
    }
    #detail-form{
        .el-upload__input{
            display: none;
        }
        .ant-table{
            width: 100%;
            th{
                text-align: center;
            }
        }
        .container{
            display: flex;
            flex-direction: column;
            padding: 24px 90px 36px 90px;
            .description{
                width: 100%;
            }
            .conform-words{
                display: flex;
                flex-direction: row;
                justify-content: space-between;
            }
        }
        .myTable{
            th, td{
                text-align: center;
            }
        }
    }
</style>
