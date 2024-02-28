<template>
    <div id="home">
        <Title :title="title"/>
        <div class="button-area">
            <!-- <a-select :value="tableValue" style="width: 120px;margin-right: 10px;" @change="changeValue" :loading="tableLoading">
                 <a-select-option  :value="''">请选择</a-select-option>
                 <a-select-option  v-for="item in selectValue" :value="item.id" :key="item.id">{{item.tableChineseName}}</a-select-option>
             </a-select>
             <a-button type="primary" icon="search" @click="showTable">查看</a-button>
             <a-button type="danger" icon="delete" @click="deleteMany">批量删除</a-button>
             <a-button icon="plus" @click="addTagGroup" >新建</a-button>-->
            <a-button type="primary" icon="pushpin" @click="changeHeader">筛选显示</a-button>
        </div>
        <a-spin :spinning="initLoading" tip="获取数据中...">
            <a-table class="tag-table"
                     :columns="columns"
                     :dataSource="dataSource"
                     :pagination="pagination"
                     :rowKey="'pathID'"
                     @change="handleTableChange">
                <template slot="operation" slot-scope="text">
                    <a href="javascript:;" @click="editOperation(text)">编辑</a>
                    <a href="javascript:;" @click="showTag(text)" v-if="!text.hasCreate">查看</a>
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
                        <a-form-item label="表名称"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-select
                                    v-decorator="[
                                                              'tableId',
                                                              {    initialValue: editInfo.tableId || undefined,
                                                                   rules: [
                                                                             {   required: true, message: '请选择表名称!' }]
                                                              }
                                                            ]"
                                    placeholder="请选择表名称"
                                    :disabled="!!editInfo.tableId"
                            >
                                <a-select-option  v-for="item in selectValue" :value="item.id" :key="item.id">
                                    {{item.tableChineseName}}
                                </a-select-option>
                            </a-select>
                        </a-form-item>
                    </a-col>
                    <a-col :span="24">
                        <a-form-item label="标签组名称"
                                     :label-col="formItemLayout.labelCol"
                                     :wrapper-col="formItemLayout.wrapperCol">
                            <a-input v-decorator="[
                                             'tagGroupName',
                                             {   initialValue: editInfo.tagGroupName || undefined,
                                                 rules: [
                                                 {   required: true, message: '请输入标签组名称!' }] }
                                                ]"
                                     placeholder="请输入标签组名称">
                            </a-input>
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
    import {reqCountChange } from "../../api/main";
    export default {
        name: "Change",
        data () {
            return {
                columns: [],
                showHeader: false,
                editInfo:{
                    tagGroupName: '',
                    tableId: '',
                    id: ''
                },
                defaultColumns: [{
                    id: 1,
                    name: 'pathID',
                    title: '序号'
                }, {
                    id: 2,
                    name: 'ptpathName',
                    title: '名称',
                    /*                    scopedSlots: true*/
                }, {
                    id: 3,
                    name: 'mutationRate',
                    title: '变异率'
                }],
                options: [  { label: '序号', value: 'pathID' },
                    { label: '名称', value: 'pathName' },
                    { label: '变异率', value: 'mutationRate' }],
                showColumns: [],
                dataSource: [],
                initLoading: false,
                tableValue: '',
                selectValue: [],
                tableHeader: [],
                title: '路径变异率',
                tableId: '',
                visible: false,
                confirmLoading: false,
                tableLoading: false,
                modalTitle: '新增标签组',
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
            async getTableData () {
                this.initLoading = true;
                const result = await reqCountChange();

                const { code, message, messageBody } = result.data;

                if (code === 0){
                    this.dataSource = messageBody;
                } else {
                    this.$message.error(message);
                }

                this.initLoading = false;
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
                /*this.columns.push({
                    title: '操作',
                    scopedSlots: { customRender: 'operation' }
                });*/

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
            changeHeader () {
                this.modalTitle = '筛选表头';
                this.showHeader = true;
                this.visible = true;
            },
            editOperation (tagGroup) {
                this.modalTitle = '编辑标签组';
                this.showHeader = false;
                this.editInfo.tagGroupName = tagGroup.tagGroupName;
                this.editInfo.tableId = tagGroup.tableId;
                this.editInfo.id = tagGroup.id;
                this.visible = true;
            },
            showTag (tagGroup) {
                this.$router.push("/auth/tag/" + tagGroup.tableId + '/' + tagGroup.id);
            },
            deleteOperation (tagGroup) {
                Modal.confirm({
                    title: '删除标签组',
                    content: '确定要删除 ' + tagGroup.tagGroupName + ' 吗?',
                    okText: '确认',
                    cancelText: '取消',
                    onOk: () => {

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
                    onOk: () => {

                    }
                })
            },
            addTagGroup () {
                this.modalTitle = '新增标签组';
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
                    /*okColumns.push({
                        title: '操作',
                        scopedSlots: { customRender: 'operation' }
                    });*/
                    this.columns = okColumns;
                    this.visible = false;
                } else {
                    this.form.validateFields( (err, /*values*/) => {
                        if (err){
                            return false;
                        }
                        this.confirmLoading = true;
                        /*if (!this.editInfo.tableId){

                        } else {
                            values.id = this.editInfo.id;

                        }*/
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
    }
    .tagGroup-modal{
        .ant-btn{
            margin-top: 20px;
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