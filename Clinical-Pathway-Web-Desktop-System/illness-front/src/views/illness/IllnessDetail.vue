<template>
    <div id="add-form">
        <Title :title="'患者路径详情'"/>
        <div class="container">
            <div class="add-title">
                <i class="title-icon"/>
                基本信息
            </div>
            <div class="basic-area">
               <div class="basic-form">
                   <a-form :form="form">
                       <a-row>
                           <a-col :span="8">
                               <a-form-item label="科室"
                                            :label-col="formItemLayout.labelCol"
                                            :wrapper-col="formItemLayout.wrapperCol">
                                   <a-input v-decorator="[
                                         'ptpathEntrdept',
                                         {   initialValue: illnessInfo.ptpathEntrdept && illnessInfo.ptpathEntrdept || undefined,
                                             rules: [
                                             {   required: true, message: '请输入科室!' }] }
                                            ]"
                                            placeholder="请输入科室" :disabled="true">
                                   </a-input>
                               </a-form-item>
                           </a-col>
                           <a-col :span="8">
                               <a-form-item label="患者姓名"
                                            :label-col="formItemLayout.labelCol"
                                            :wrapper-col="formItemLayout.wrapperCol">
                                   <a-input v-decorator="[
                                         'ptName',
                                         {   initialValue: illnessInfo.ptName && illnessInfo.ptName,
                                             rules: [{
                                             required: true, message: '请填写患者姓名!' }] }
                                            ]"
                                            placeholder="请输入患者姓名" :disabled="true">
                                   </a-input>
                               </a-form-item>
                           </a-col>
                           <a-col :span="8">
                               <a-form-item label="性别"
                                            :label-col="formItemLayout.labelCol"
                                            :wrapper-col="formItemLayout.wrapperCol">
                                   <a-input v-decorator="[
                                         'ptGender',
                                         {
                                             initialValue: illnessInfo.ptGender === 0 ? '男' : '女',
                                         }
                                            ]"
                                            placeholder="请输入性别" :disabled="true">
                                   </a-input>
                               </a-form-item>
                           </a-col>
                       </a-row>
                       <a-row>
                           <a-col :span="8">
                               <a-form-item label="年龄"
                                            :label-col="formItemLayout.labelCol"
                                            :wrapper-col="formItemLayout.wrapperCol">
                                   <a-input v-decorator="[
                                         'ptAge',
                                         {
                                             initialValue: illnessInfo.ptAge && illnessInfo.ptAge || undefined,
                                         }
                                            ]"
                                            placeholder="请输入年龄" :disabled="true">
                                   </a-input>
                               </a-form-item>
                           </a-col>
                           <a-col :span="8">
                               <a-form-item label="病床号"
                                            :label-col="formItemLayout.labelCol"
                                            :wrapper-col="formItemLayout.wrapperCol">
                                   <a-input v-decorator="[
                                         'ptBed',
                                         {
                                             initialValue: illnessInfo.ptBed && illnessInfo.ptBed || undefined,
                                         }
                                            ]"
                                            placeholder="请输入病床号" :disabled="true">
                                   </a-input>
                               </a-form-item>
                           </a-col>
                           <a-col :span="8">
                               <a-form-item label="入院时间"
                                            :label-col="formItemLayout.labelCol"
                                            :wrapper-col="formItemLayout.wrapperCol">
                                   <a-input v-decorator="[
                                         'ptStartdate',
                                         {
                                             initialValue: illnessInfo.ptStartdate && illnessInfo.ptStartdate || undefined,
                                         }
                                            ]"
                                            placeholder="请输入入院时间" :disabled="true">
                                   </a-input>
                               </a-form-item>
                           </a-col>
                       </a-row>
                   </a-form>
               </div>
                <div class="basic-box">
                    <div class="box-all">
                        <div class="box-title">
                            临床路径: {{illnessInfo.pathName && illnessInfo.pathName || '-'}}
                        </div>
                        <div class="box-info">
                            标准住院日: {{illnessInfo.pathSlos && illnessInfo.pathSlos || '-'}}
                        </div>
                    </div>
                </div>
            </div>
            <div class="add-title">
                <i class="title-icon"/>
                进行操作
            </div>
            <div class="operation">
                <a-button type="link" icon="plus" @click="showPath">路径变异</a-button>
                <a-button type="link" icon="plus" @click="finishPath">路径完成</a-button>
            </div>
            <div class="table-data" style="padding: 20px 0;">
                <a-collapse>
                    <a-collapse-panel  :header="'第' + item.pathsegDay + '天'" :disabled="false" v-for="item in content" :key="item.pathsegID">
                        <a-list :grid="{ gutter: 16, xxl: 2 }" :data-source="item.group">
                            <a-list-item slot="renderItem" slot-scope="cItem">
                                <a-card :title="cItem.itemCat">
                                    <a-checkbox-group name="checkboxgroup"
                                                      v-model="cItem.checkedHeader"
                                                      :options="cItem.options"
                                                      v-if="cItem.options" @change="handleChange">
                                    </a-checkbox-group>
                                    <div class="textarea" v-if="!cItem.checkedHeader">
                                        <a-col :span="24">
                                            <label>温度: </label>
                                            <a-input v-model="cItem.ptpathsegTemp" />
                                        </a-col>
                                        <a-col :span="24" style="margin-top: 15px;">
                                        <label>备注: </label>
                                        <a-textarea v-model="cItem.ptitemExecrem" style="height: 100px;"/>
                                        </a-col>
                                    </div>
                                </a-card>
                            </a-list-item>
                        </a-list>
                    </a-collapse-panel>
                </a-collapse>
            </div>
        </div>
        <a-modal :title="'路径变异'"
                 v-model="visible"
                 @ok="handleOk"
                 :class="['common-modal', 'tagGroup-modal']"
                 :destroyOnClose="true"
                 :keyboard="true"
                 :maskClosable="false"
                 :okText="'确认'"
                 :cancelText="'取消'"
                 :confirmLoading="confirmLoading">
            <div class="add-tag-group" >
                <a-form :form="form">
                    <a-col :span="24">
                        <a-form-item label="变异原因"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-textarea v-decorator="[
                                             'ptpathVarrsn',
                                             {
                                                 rules: [
                                                 {   required: true, message: '请输入变异原因!' }] }
                                                ]"
                                     placeholder="请输入变异原因" style="height: 150px;">
                            </a-textarea>
                        </a-form-item>
                    </a-col>
                </a-form>
            </div>
        </a-modal>
        <div class="modal-button">
            <a-button shape="round" type="primary" id="cancelButton" @click="cancel">取消</a-button>
            <a-button shape="round" type="primary" id="okButton" @click="submitData" :loading="confirmLoading">确定</a-button>
        </div>
    </div>
</template>

<script>
    import Title from '@/components/contentTitle';
    import { Modal } from 'ant-design-vue'
    import {reqIllnessDetail, reqMutations, reqPathChange,/* reqPathChange,*/ reqPathComplete} from "../../api/main";
    export default {
        name: "IllnessDetail",
        data () {
            return {
                form: this.$form.createForm(this),
                editInfo: {},
                formItemLayout: {
                    labelCol: { span: 7 },
                    wrapperCol: { span: 16 }
                },
                illnessInfo: {},
                content: [],
                visible: false,
                confirmLoading: false,
                data: [
                    {   id: 1,
                        title: '主要诊疗工作',
                        options: [{ label: '询问病史', value: 'id' },
                            /* { label: '所属字段', value: 'tableColumnId' },*/
                            /* { label: '所属标签组', value: 'tagGroupId' },*/
                            { label: '及时告知', value: 'tagName' }],
                        checkedHeader: [ ],
                    },
                    {   id: 2,
                        title: '医嘱',
                        options: [{ label: '询问病史', value: 'id' },
                            /* { label: '所属字段', value: 'tableColumnId' },*/
                            /* { label: '所属标签组', value: 'tagGroupId' },*/
                            { label: '及时告知', value: 'tagName' }],
                        checkedHeader: [],
                    },
                    {   id: 3,
                        title: '主要护理工作',
                        options: [ { label: '询问病史', value: 'id' },
                            /* { label: '所属字段', value: 'tableColumnId' },*/
                            /* { label: '所属标签组', value: 'tagGroupId' },*/
                            { label: '及时告知', value: 'tagName' }],
                        checkedHeader: [],
                    },
                    {   id: 4,
                        title: '备注',
                        text: '这是填备注的地方'
                    },
                ]
            }
        },
        methods: {
            cancel () {
                this.$router.go(-1);
            },
            async getPatientDetail () {
                const result = await reqIllnessDetail({
                    ptID: this.$route.query.ptID
                });

                const { code, message, messageBody } = result.data;

                if (code === 0){
                    const { info, content } = messageBody;
                    this.illnessInfo = info;
                    content.map( item => {
                        item.group.map( cItem => {
                            cItem.checkedHeader = [];
                            cItem.options = [];
                            cItem.item.map(dItem => {
                                cItem.options.push({
                                    label: dItem.itemName,
                                    value: dItem.itemID
                                })
                            });
                        });

                        item.group.push({
                            itemCat: '温度和备注',
                            ptpathsegTemp: '',
                            ptitemExecrem: '',
                            itemID: 9999,
                            pathsegID: item.pathsegID
                        });
                    });
                    this.content = content;

                } else {
                    this.$message.error(message);
                }
            },
            async handleChange (/*itemID*/) {

                /*const result = await reqPathChange();*/

             /*   this.content.map( item => {
                    item.group.map( cItem => {
                        cItem.item.map(dItem => {
                           if (dItem.itemID === itemID){
                               single = dItem;
                           }
                        });
                    });
                });*/
            },
            async submitData () {
                const formData = [];

                this.content.map( item => {
                    item.group.map( cItem => {
                        if (cItem.checkedHeader){
                            const checkedItem = [];
                            cItem.checkedHeader.map(fItem => {
                                checkedItem.push(cItem.item.find(value => value.itemID === fItem));
                            });
                            const result = formData.findIndex(value => value.pathsegID === cItem.pathsegID);
                            if (~result){
                                formData[result].item = formData[result].item.concat(checkedItem);
                            } else {
                                const single = {};
                                single.ptpathID = this.illnessInfo.ptpathID;
                                single.pathsegID = cItem.pathsegID;
                                single.item = checkedItem;
                                single.ptpathsegTemp = item.group[item.group.length - 1].ptpathsegTemp;
                                single.ptitemExecrem = item.group[item.group.length - 1].ptitemExecrem;
                                formData.push(single);
                            }
                        }
                    });
                });

                const result = await reqPathChange(formData);

                const { code, message } = result.data;

                code === 0 && this.$message.success(message) && this.$router.go(-1);
                code !== 0 && this.$message.error(message);
            },
            handleOk () {
                this.form.validateFields(['ptpathVarrsn'], async (err, values) => {
                    if (err){
                        return false;
                    }
                    const result = await reqMutations({
                       ptpathID: this.illnessInfo.ptpathID,
                        ...values
                    });

                    const { code, message } = result.data;

                    code === 0 && this.$message.success(message) && this.getPatientDetail();
                    code !== 0 && this.$message.error(message);
                });

                this.confirmLoading = false;
                this.visible = false;
            },
            showPath () {
              this.editInfo = {};
              this.visible = true;
            },
            finishPath () {
                Modal.confirm({
                    title: '完成路径',
                    content: '确定要完成路径信息吗?',
                    okText: '确认',
                    cancelText: '取消',
                    onOk: async () => {
                        const result = await reqPathComplete({
                            ptpathID: this.illnessInfo.ptpathID
                        });

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message);
                        code !== 0 && this.$message.error(message);
                    }
                })
            },
            confirm () {
                this.confirmLoading = true;
                this.form.validateFields( (err , /*values*/) => {
                    if (err){
                        this.confirmLoading = true;
                        return false;
                    }
                });
            }
        },
        mounted() {
            this.getPatientDetail();
        },
        components: {
            Title
        }
    }
</script>

<style lang="less">
.basic-area{
    display: flex;
    flex-direction: row;
    .basic-form{
        width: 1200px;
    }
    .basic-box{
        flex: 1;
        padding-left: 100px;
        .box-all{
            width: 300px;
            height: 100px;
            padding: 30px;
            border-radius: 10px;
            border: 2px dotted #F8F8F8;
        }
    }
}
.operation{
    .ant-btn{
        margin-right: 15px;
    }
}
.table-data{
    .ant-checkbox-group-item{
        white-space: nowrap;
        text-overflow:ellipsis;
        overflow: hidden;
    }
}
</style>