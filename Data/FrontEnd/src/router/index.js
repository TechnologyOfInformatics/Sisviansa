import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/user/HomeView.vue'
import FaqView from '@/views/user/FaqView.vue'
import AuthView from '@/views/user/AuthView.vue'
import ShopView from '@/views/user/ShopView.vue'
import CartView from '@/views/user/CartView.vue'
import ProfileView from '@/views/user/ProfileView.vue'
import BussinesView from '@/views/user/BussinesView.vue'


import AdminAuthView from '@/views/admin/AuthView.vue'
import AdminUserView from '@/views/admin/UserView.vue'
import AdminMenuView from '@/views/admin/MenuView.vue'

import TestView from '@/views/TestView.vue'
const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/login',
    name: 'login',
    component: AuthView
  },
  {
    path: '/faq',
    name: 'faq',
    component: FaqView
  },
  {
    path: '/shop',
    name: 'shop',
    component: ShopView
  },

  {
    path: '/cart',
    name: 'cart',
    component: CartView
  },
  {
    path: '/profile',
    name: 'profile',
    component: ProfileView
  },
  {
    path: '/bussines',
    name: 'bussines',
    component: BussinesView
  },

  {
    path: '/admin/auth',
    name: 'adminAuth',
    component: AdminAuthView
  },
  {
    path: '/admin/user',
    name: 'adminUser',
    component: AdminUserView
  },
  {
    path: '/admin/menu',
    name: 'adminMenu',
    component: AdminMenuView
  },


  {
    path: '/test',
    name: 'test',
    component: TestView
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router