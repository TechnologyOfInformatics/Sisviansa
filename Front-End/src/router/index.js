import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/user/HomeView.vue'
import FaqView from '@/views/user/FaqView.vue'
import AuthView from '@/views/user/AuthView.vue'
import ShopView from '@/views/user/ShopView.vue'
import CartView from '@/views/user/CartView.vue'

import AdminAuthView from '@/views/admin/AuthView.vue'
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
    path: '/admin/login',
    name: 'adminlogin',
    component: AdminAuthView
  },
  {
    path: '/cart',
    name: 'cart',
    component: CartView
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router