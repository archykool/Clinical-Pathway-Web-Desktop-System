import Store from "store";

export default {
    getToken () {
        return Store.get('token') || '';
    },
    setToken (token) {
        return Store.set('token', token);
    },
    delToken () {
        return Store.remove('token');
    },
    getInfo () {
        if (Store.get('user')){
            return JSON.parse(Store.get('user'));
        } else {
            return null;
        }
    },
    setInfo (info){
        return Store.set('user', JSON.stringify(info));
    },
    delInfo (){
        return Store.remove('user');
    }
}