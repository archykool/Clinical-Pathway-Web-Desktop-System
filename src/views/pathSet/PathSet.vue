<template>
    <div id="home">
        <Title :title="title"/>
        <div class="button-area">
             科室:
             <a-select :value="pathDept" style="width: 192px;margin-right: 10px;" @change="changeDept">
                 <a-select-option  :value="''">请选择</a-select-option>
                 <a-select-option  v-for="item in selectValue" :value="item.name" :key="item.id">{{item.name}}</a-select-option>
             </a-select>
            <a-input :value="pathName" style="width: 192px;margin-right: 10px;" @change="changeName"  placeholder="请输入路径名称"/>
             <a-button type="primary" icon="search" @click="showTable">搜索路径</a-button>
             <a-button type="danger" icon="delete" @click="deleteMany">批量删除</a-button>
             <a-button icon="plus" @click="addTagGroup" >新增路径</a-button>
            <a-button type="primary" icon="pushpin" @click="changeHeader">筛选显示</a-button>
        </div>
        <a-spin :spinning="initLoading" tip="获取数据中...">
            <a-table class="tag-table"
                     :columns="columns"
                     :dataSource="dataSource"
                     :pagination="pagination"
                     :rowSelection="rowSelection"
                     :rowKey="'pathID'"
                     @change="handleTableChange"
                     >
                <template slot="operation" slot-scope="text">
                    <a href="javascript:;" @click="editOperation(text)">修改</a>
                    <!--<a href="javascript:;" @click="showTag(text)" v-if="!text.hasCreate">查看</a>-->
                    <a href="javascript:;" @click="deleteOperation(text)">删除</a>
                </template>
            </a-table>
        </a-spin>
        <a-modal :title="modalTitle"
                 v-model="visible"
                 @ok="handleOk"
                 :class="showHeader? ['common-modal', 'personal-modal'] : ['common-modal', 'tagGroup-modal']"
                 :destroyOnClose="true"
                 :keyboard="true"
                 :maskClosable="false"
                 :closable="!showHeader"
                 :okText="'确认'"
                 :cancelText="'取消'"
                 :confirmLoading="confirmLoading">
            <div class="check-box-area" v-if="showHeader">
                <a-checkbox-group name="checkboxgroup"
                                  v-model="checkedHeader"
                                  :options="options">
                </a-checkbox-group>
            </div>
            <div class="add-tag-group" v-if="!showHeader">
                <a-form :form="form">
                    <a-col :span="24">
                        <a-form-item label="路径版本"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input-number v-decorator="[
                                             'pathVer',
                                             {   initialValue: editInfo.pathVer || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入路径版本!' }] }
                                                ]"
                                        placeholder="请输入路径版本" style="width: 275px;">
                            </a-input-number>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="路径名称"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'pathName',
                                             {   initialValue: editInfo.pathName || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入路径名称!' }] }
                                                ]"
                                     placeholder="请输入路径名称">
                            </a-input>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="疾病编码"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'pathCode',
                                             {   initialValue: editInfo.pathCode || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入疾病编码!' }] }
                                                ]"
                                     placeholder="请输入疾病编码">
                            </a-input>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="入径条件"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'pathReq',
                                             {   initialValue: editInfo.pathReq || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入入径条件!' }] }
                                                ]"
                                     placeholder="请输入入径条件">
                            </a-input>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="入院科室"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-select
                                    v-decorator="[
                                                              'pathDept',
                                                              {    initialValue: editInfo.tableId || undefined,
                                                                   rules: [
                                                                             {   required: true, message: '请选择入院科室!' }]
                                                              }
                                                            ]"
                                    placeholder="请选择入院科室"
                            >
                                <a-select-option  v-for="item in selectValue" :value="item.name" :key="item.id">
                                    {{item.name}}
                                </a-select-option>
                            </a-select>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="标准住院日"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                           <!-- <a-date-picker
                                    v-decorator="[
                                  'produce_end_time',
                                 {  initialValue: editInfo.produce_end_time && $moment(editInfo.produce_end_time, 'YYYY-MM-DD hh:mm:ss') || undefined,
                                 rules: [{   required: true, message: '请选择结束时间(个)!' }] }]"
                                                    format="YYYY-MM-DD hh:mm:ss"
                                                    :disabledDate="disabledDate"
                                                    :disabledTime="disabledDateTime"
                                                    :showTime="{ defaultValue: $moment('00:00:00', 'HH:mm:ss') }"
                                                    placeholder="请选择结束时间"
                                                    :disabled="!!editInfo.produce_end_time"
                            />-->
                            <a-input v-decorator="[
                                             'pathSlos',
                                             {   initialValue: editInfo.tagGroupName || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入标准住院日!' }] }
                                                ]"
                                     placeholder="请输入标准住院日">
                            </a-input>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="创建人"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'pathCrtstaff',
                                             {   initialValue: editInfo.pathCrtStaff || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入创建人!' }] }
                                                ]"
                                     placeholder="请输入创建人">
                            </a-input>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="摘要"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-textarea v-decorator="[
                                             'pathAbs',
                                             {   initialValue: editInfo.pathAbs || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入摘要!' }] }
                                                ]"
                                     placeholder="请输入摘要" style="height: 150px;">
                            </a-textarea>
                        </a-form-item>
                    </a-col>
                </a-form>
            </div>
        </a-modal>
    </div>
</template>

<script>
    import Title from '@/components/contentTitle';
    import { Modal } from 'ant-design-vue';
    import {reqAddPathTemplate, reqDeletePathTemplate, reqPathList} from "../../api/main";
    export default {
        name: "Change",
        data () {
            return {
                columns: [],
                showHeader: false,
                pathDept: '',
                pathName: '',
                editInfo:{
                    tagGroupName: '支气管肺炎',
                    tableId: '急诊室',
                    id: '133255',
                    creatorName: '张三',
                    creatorId: 2.0
                },
                defaultColumns: [{
                    id: 1,
                    name: 'pathCode',
                    title: '疾病编码'
                }, {
                    id: 2,
                    name: 'pathDept',
                    title: '入院科室',
                    /*                    scopedSlots: true*/
                }, {
                    id: 3,
                    name: 'pathName',
                    title: '路径名称'
                }, {
                    id: 4,
                    name: 'pathCrtstaff',
                    title: '创建人'
                }, {
                    id: 5,
                    name: 'pathVer',
                    title: '路径版本'
                }],
                options: [  { label: '疾病编码', value: 'pathCode' },
                    { label: '入院科室', value: 'pathDept' },
                    { label: '路径名称', value: 'pathName' },
                    { label: '创建人', value: 'pathCrtstaff' },
                    { label: '路径版本', value: 'pathVer' },],
                showColumns: [],
                dataSource: [],
                initLoading: false,
                tableValue: '',
                selectValue: [{
                    id: 1,
                    name: '内科'
                }, {
                    id: 2,
                    name: '外科'
                }, {
                    id: 3,
                    name: '妇科'
                }, {
                    id: 4,
                    name: '儿科'
                }],
                tableHeader: [],
                title: '路径配置模块',
                tableId: '',
                visible: false,
                confirmLoading: false,
                tableLoading: false,
                modalTitle: '新增路径模板',
                pagination: {
                    total: 0,
                    defaultCurrent: 1,
                    pageSize: 10,
                    current: 1,
                    showSizeChange (pageSize) {
                        this.pagination.pageSize = pageSize;
                    },
                    showQuickJumper: true,
                    showSizeChanger: false,
                    pageSizeOptions: ['10', '100', '1000', '5000']
                },
                rowSelection: {},
                checkedHeader: [],
                form: this.$form.createForm(this),
                formItemLayout: {
                    labelCol: { span: 7 },
                    wrapperCol: { span: 14 }
                },
                selectedId: ''
            }
        },
        methods: {
            async getTableData (data) {
                this.initLoading = true;
                const result = await reqPathList(data);

                const { code, message, messageBody } = result.data;
                if (code === 0){
                    this.dataSource = messageBody;
                } else {
                    this.$message.error(message);
                }

                this.initLoading = false;
            },
            changeDept (value) {
                this.pathDept = value;
            },
            changeName (e) {
                this.pathName = e.target.value;
            },
            tableInit () {
                this.showColumns = this.defaultColumns;
                this.showColumns.map(( item ) => {
                    if (item.scopedSlots){
                        this.columns.push({
                            title: item.title,
                            key: item.name,
                            dataIndex: item.name,
                            scopedSlots: { customRender: item.name }
                        });
                    } else {
                        this.columns.push({
                            title: item.title,
                            key: item.name,
                            dataIndex: item.name
                        });
                    }
                    return item;
                });
                this.columns.push({
                    title: '操作',
                    scopedSlots: { customRender: 'operation' }
                });

                this.rowSelection = {
                    onChange: (selectedRowKeys) => {
                        this.selectedId = selectedRowKeys;
                    },
                    onSelect: (record, selected, selectedRows) => {
                        console.log(record, selected, selectedRows);
                    },
                    onSelectAll: (selected, selectedRows, changeRows) => {
                        console.log(selected, selectedRows, changeRows);
                    }
                }
            },
            range(start, end) {
                const result = [];
                for (let i = start; i < end; i++) {
                    result.push(i);
                }
                return result;
            },
            disabledDate(current) {
                // Can not select days before today and today
                return current && current < this.$moment().endOf('day');
            },
            disabledDateTime() {
                return {
                    disabledHours: () => this.range(0, 24).splice(4, 20),
                    disabledMinutes: () => this.range(30, 60),
                    disabledSeconds: () => [55, 56],
                };
            },
            changeHeader () {
                this.modalTitle = '筛选表头';
                this.showHeader = true;
                this.visible = true;
            },
            editOperation (tagGroup) {
             this.$router.push({ path: '/auth/pathSetDetail', query: tagGroup });
            },
            showTag (tagGroup) {
                this.$router.push("/auth/tag/" + tagGroup.tableId + '/' + tagGroup.id);
            },
            deleteOperation (tagGroup) {
                Modal.confirm({
                    title: '删除路径',
                    content: '确定要删除 ' + tagGroup.pathName + ' 吗?',
                    okText: '确认',
                    cancelText: '取消',
                    onOk: async () => {
                        const result = await reqDeletePathTemplate([tagGroup.pathID]);

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getTableData();
                        code !== 0 && this.$message.error(message);
                    }
                })
            },
            deleteMany () {
                if (this.selectedId.length === 0){
                    return this.$message.warning('请先选择批量删除项');
                }
                Modal.confirm({
                    title: '批量删除标签组',
                    content: '确定要批量删除这些标签组吗?',
                    okText: '确认',
                    cancelText: '取消',
                    onOk: async () => {
                        const result = await reqDeletePathTemplate(this.selectedId);

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getTableData();
                        code !== 0 && this.$message.error(message);
                    }
                })
            },
            addTagGroup () {
                this.modalTitle = '新增路径模板';
                this.editInfo.tagGroupName = '';
                this.editInfo.tableId = '';
                this.editInfo.id = '';
                this.showHeader = false;
                this.visible = true;
            },
            showSearchForm () {

            },
            showTable () {
                this.initLoading = true;
                this.getTableData({
                    pathDept: this.pathDept,
                    pathName: this.pathName
                });
            },
            handleOk () {
                if (this.showHeader){
                    const okColumns = [];
                    this.showColumns.map( item => {
                        this.checkedHeader.map( cItem => {
                            if (cItem === item.name){
                                if (item.scopedSlots){
                                    okColumns.push({
                                        title: item.title,
                                        key: item.name,
                                        dataIndex: item.name,
                                        scopedSlots: { customRender: item.name }
                                    });
                                } else {
                                    okColumns.push({
                                        title: item.title,
                                        key: item.name,
                                        dataIndex: item.name
                                    });
                                }
                            }
                        });
                    });
                    okColumns.push({
                        title: '操作',
                        scopedSlots: { customRender: 'operation' }
                    });
                    this.columns = okColumns;
                    this.visible = false;
                } else {
                    this.form.validateFields( async (err, values) => {
                        if (err){
                            return false;
                        }
                        this.confirmLoading = true;

                        const result = await reqAddPathTemplate(values);

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getTableData();
                        code !== 0 && this.$message.success(message);

                        this.confirmLoading = false;
                        this.visible = false;
                    })
                }
            },
            handleTableChange (pagination) {
                this.pagination.current = pagination.current;
                this.showTable();
            },
        },
        computed: {
        },
        components:{
            Title
        },
        mounted() {
            this.getTableData();
            this.tableInit();
            this.checkedHeader = this.options.map( item => item.value);
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
        .ant-input-number{
            background: #F7F9FA !important;
        }
        .ant-input-number:focus{
            background: #ffffff !important;
        }
    }
    .tagGroup-modal{
        .ant-btn{
            margin-top: 20px;
        }
        .ant-calendar-picker{
            width: 100% !important;
        }
    }
    .personal-modal{
        .ant-btn{
            &:nth-child(1){
                display: none;
            }
        }
    }
</style>