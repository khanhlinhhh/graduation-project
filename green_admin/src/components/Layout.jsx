import { NavLink, useNavigate } from 'react-router-dom';
import { signOut } from 'firebase/auth';
import { auth } from '../firebase';
import {
    LayoutDashboard,
    Users,
    Gift,
    CalendarCheck,
    Lightbulb,
    LogOut,
    Leaf
} from 'lucide-react';

const navItems = [
    { path: '/', icon: LayoutDashboard, label: 'Dashboard' },
    { path: '/users', icon: Users, label: 'Người dùng' },
    { path: '/rewards', icon: Gift, label: 'Phần thưởng' },
    { path: '/checkins', icon: CalendarCheck, label: 'Check-ins' },
    { path: '/tips', icon: Lightbulb, label: 'Mẹo xanh' },
];

export default function Layout({ children }) {
    const navigate = useNavigate();

    const handleLogout = async () => {
        await signOut(auth);
        navigate('/login');
    };

    return (
        <div className="flex min-h-screen bg-gray-50">
            {/* Sidebar */}
            <aside className="w-64 bg-gradient-to-b from-green-600 to-green-700 text-white flex flex-col shadow-xl">
                {/* Logo */}
                <div className="p-6 border-b border-green-500/30">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center">
                            <Leaf className="w-6 h-6" />
                        </div>
                        <div>
                            <h1 className="font-bold text-lg">Green Admin</h1>
                            <p className="text-green-200 text-xs">Quản lý ứng dụng</p>
                        </div>
                    </div>
                </div>

                {/* Navigation */}
                <nav className="flex-1 p-4 space-y-1">
                    {navItems.map((item) => (
                        <NavLink
                            key={item.path}
                            to={item.path}
                            end={item.path === '/'}
                            className={({ isActive }) =>
                                `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 ${isActive
                                    ? 'bg-white text-green-600 shadow-lg font-medium'
                                    : 'text-green-100 hover:bg-white/10'
                                }`
                            }
                        >
                            <item.icon className="w-5 h-5" />
                            <span>{item.label}</span>
                        </NavLink>
                    ))}
                </nav>

                {/* Logout */}
                <div className="p-4 border-t border-green-500/30">
                    <button
                        onClick={handleLogout}
                        className="flex items-center gap-3 px-4 py-3 w-full text-green-100 hover:bg-white/10 rounded-xl transition-all duration-200"
                    >
                        <LogOut className="w-5 h-5" />
                        <span>Đăng xuất</span>
                    </button>
                </div>
            </aside>

            {/* Main content */}
            <main className="flex-1 overflow-auto">
                {children}
            </main>
        </div>
    );
}
