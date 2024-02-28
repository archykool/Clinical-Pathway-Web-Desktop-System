<template>
    <div id="home">
        <Title :title="title"/>
        <div class="button-area">
            科室:
            <a-select :value="tableValue" style="width: 192px;margin-right: 10px;" @change="(value) => { tableValue = value;}">
                <a-select-option  :value="''">请选择</a-select-option>
                <a-select-option  v-for="item in selectValue" :value="item.name" :key="item.id">{{item.name}}</a-select-option>
            </a-select>
            病种:
            <a-select :value="illness" style="width: 192px;margin-right: 10px;" @change="(value) => { illness = value;}">
                <a-select-option  :value="''">请选择</a-select-option>
                <a-select-option  v-for="item in illnessList" :value="item.pathName" :key="item.pathID">{{item.pathName}}</a-select-option>
            </a-select>
            路径状态:
            <a-select :value="status" style="width: 192px;margin-right: 10px;" @change="changeValue" :loading="tableLoading">
                <a-select-option  :value="''">请选择</a-select-option>
                <a-select-option  v-for="item in statusList" :value="item.id" :key="item.id">{{item.name}}</a-select-option>
            </a-select>
            <a-input  v-model="patientName" style="width: 192px;margin-right: 10px;" placeholder="请输入患者名称"/>
            <a-button type="primary" icon="search" @click="showTable">搜索患者</a-button>
            <a-button type="danger" icon="delete" @click="deleteMany">批量删除</a-button>
            <a-button icon="plus" @click="addTagGroup" >新增患者</a-button>
            <a-button type="primary" icon="pushpin" @click="changeHeader">筛选显示</a-button>
        </div>
        <a-spin :spinning="initLoading" tip="获取数据中...">
            <a-table class="tag-table"
                     :columns="columns"
                     :dataSource="dataSource"
                     :pagination="pagination"
                     :rowSelection="rowSelection"
                     :rowKey="'ptID'"
                     @change="handleTableChange">
                <span slot="ptPathcond" slot-scope="text">
                  {{text === 0 &&  '未入径' || text === 1 && '进行中' || text === 2 && '已结束'}}
                </span>
                <span slot="ptGender" slot-scope="text">
                  {{text === 0 ? '男' : '女'}}
                </span>
                <template slot="operation" slot-scope="text">
                    <a href="javascript:;" @click="editOperation(text)">管理</a>
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
                        <a-form-item label="姓名"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'ptName',
                                             {   initialValue: editInfo.ptName || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入姓名!' }] }
                                                ]"
                                     placeholder="请输入姓名">
                            </a-input>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="性别"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-select v-decorator="[
                                             'ptGender',
                                             {   initialValue: editInfo.ptGender || undefined,
                                                 rules: [
                                                 {   required: true, message: '请选择性别!' }] }
                                                ]"
                                     placeholder="请选择性别">
                                <a-select-option :value="0">
                                    男
                                </a-select-option>
                                <a-select-option :value="1">
                                    女
                                </a-select-option>
                            </a-select>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="年龄"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'ptAge',
                                             {   initialValue: editInfo.ptAge || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入年龄!' }] }
                                                ]"
                                     placeholder="请输入年龄">
                            </a-input>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="入院时间"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                             <a-date-picker
                                     v-decorator="[
                                   'ptStartdate',
                                  {  initialValue: editInfo.ptStartdate && $moment(editInfo.ptStartdate, 'YYYY-MM-DD hh:mm:ss') || undefined,
                                  rules: [{   required: true, message: '请选择入院时间!' }] }]"
                                                     format="YYYY-MM-DD hh:mm:ss"
                                                     :disabledDate="disabledDate"
                                                     :disabledTime="disabledDateTime"
                                                     :showTime="{ defaultValue: $moment('00:00:00', 'HH:mm:ss') }"
                                                     placeholder="请选择入院时间"
                             />
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="入院病种"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-select
                                    v-decorator="[
                                                              'pathID',
                                                              {    initialValue: editInfo.pathID || undefined,
                                                                   rules: [
                                                                             {   required: true, message: '请选择入院病种!' }]
                                                              }
                                                            ]"
                                    placeholder="请选择入院病种"
                            >
                                <a-select-option  v-for="item in illnessList" :value="item.pathID" :key="item.pathID">
                                    {{item.pathName}}
                                </a-select-option>
                            </a-select>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="是否入径"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-select v-decorator="[
                                             'type',
                                             {   initialValue: editInfo.type || undefined,
                                                 rules: [
                                                 {   required: true, message: '请选择是否入径!' }] }
                                                ]"
                                      placeholder="请选择是否入径">
                                <a-select-option :value="0">
                                    不入径
                                </a-select-option>
                                <a-select-option :value="1">
                                    入径
                                </a-select-option>
                            </a-select>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="床位"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input-number v-decorator="[
                                             'ptBed',
                                             {   initialValue: editInfo.ptBed || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入床位!' }] }
                                                ]"
                                     placeholder="请输入床位">
                            </a-input-number>
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
    import {reqAddIllness, reqDeleteIllness, reqIllnessList, reqPatientList} from "../../api/main";
    export default {
        name: "Illness",
        data () {
            return {
                columns: [],
                showHeader: false,
                illness: '',
                patientName: '',
                editInfo:{
                    tagGroupName: '支气管肺炎',
                    tableId: '急诊室',
                    id: '133255',
                    creatorName: '张三',
                    creatorId: 2.0
                },
                defaultColumns: [{
                    id: 1,
                    name: 'ptID',
                    title: '编号'
                }, {
                    id: 2,
                    name: 'ptPathcond',
                    title: '路径状态',
                    scopedSlots: true
                    /*                    scopedSlots: true*/
                }, {
                    id: 3,
                    name: 'ptStartdate',
                    title: '入院时间'
                }, {
                    id: 4,
                    name: 'ptName',
                    title: '姓名'
                }, {
                    id: 5,
                    name: 'ptGender',
                    title: '性别',
                    scopedSlots: true
                }, {
                    id: 6,
                    name: 'ptAge',
                    title: '年龄'
                }, {
                    id: 7,
                    name: 'ptpathName',
                    title: '路径名称'
                }],
                options: [ { label: '编号', value: 'ptID' },
                    { label: '路径状态', value: 'ptPathcond' },
                    { label: '入院时间', value: 'ptStartdate' },
                    { label: '姓名', value: 'ptName' },
                    { label: '性别', value: 'ptGender' },
                    { label: '年龄', value: 'ptAge' },
                    { label: '路径名称', value: 'ptpathName' },],
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
                illnessList: [],
                title: '患者路径管理',
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
                statusList: [{
                    id: 0,
                    name: '未入径'
                }, {
                    id: 1,
                    name: '进行中'
                }, {
                    id: 3,
                    name: '已结束'
                }],
                status: '',
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
                const result = await reqPatientList(data);

                const { code, message, messageBody } = result.data;
                if (code === 0){
                    this.dataSource = messageBody;
                } else {
                    this.$message.error(message);
                }

                this.initLoading = false;
            },
            async getIllnessList () {
              const result = await reqIllnessList();

              const { code, message , messageBody } = result.data;

              if (code === 0){
                  this.illnessList = messageBody;
              } else {
                  this.$message.error(message);
              }
            },
            changeValue (value) {
                this.tableValue = value;
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
               this.$router.push({ path: '/auth/illnessDetail', query: tagGroup});
            },
            showTag (tagGroup) {
                this.$router.push("/auth/tag/" + tagGroup.tableId + '/' + tagGroup.id);
            },
            deleteOperation (patient) {
                Modal.confirm({
                    title: '删除患者',
                    content: '确定要删除该患者信息吗?',
                    okText: '确认',
                    cancelText: '取消',
                    onOk: async () => {
                        const result = await reqDeleteIllness([patient.ptID]);

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getTableData();
                        code !== 0 && this.$message.success(message);
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
                        const result = await reqDeleteIllness(this.selectedId);

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getTableData();
                        code !== 0 && this.$message.success(message);
                    }
                })
            },
            addTagGroup () {
                this.modalTitle = '患者入径管理';
                this.editInfo = {};
                this.showHeader = false;
                this.visible = true;
            },
            showSearchForm () {

            },
            showTable () {
                this.initLoading = true;
                this.getTableData({
                    ptName: this.patientName,
                    ptpathEntrdept: this.tableValue,
                    ptPathcond: this.status,
                    ptpathName: this.illness
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

                        values.ptStartdate = this.$moment(values.ptStartdate).format('YYYY-MM-DD hh:mm:ss');
                        const result = await reqAddIllness({
                            ...values
                        });

                        const { code, message } = result.data;

                        code === 0 && this.$message.success(message) && this.getTableData();
                        code !== 0 && this.$message.error(message);

                        this.confirmLoading = false;
                        this.visible = false;
                    });
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
            this.getIllnessList();
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
        .ant-input-number{
            background: #F7F9FA !important;
            width: 274px;
        }
        .ant-input-number:focus{
            background: #ffffff !important;
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
    }
    .personal-modal{
        .ant-btn{
            &:nth-child(1){
                display: none;
            }
        }
    }
</style>