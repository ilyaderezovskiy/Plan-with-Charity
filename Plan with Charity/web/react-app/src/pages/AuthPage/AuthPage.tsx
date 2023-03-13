import React from "react";
import Typography from "@mui/material/Typography";
import './AuthPage.css';
import { AuthForm } from './AuthForm/AuthForm.tsx';

export const AuthPage: React.FC = ({ navigation }) => {
    return (
        <div className="AuthPage">
            <AuthForm navigation={navigation}/>
        </div>
    )
}