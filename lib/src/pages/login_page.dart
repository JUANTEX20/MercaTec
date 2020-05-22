import 'package:flutter/material.dart';
import 'package:comunidadmercado/src/bloc/provider.dart';
import 'package:comunidadmercado/src/providers/usuario_provider.dart';

import 'package:comunidadmercado/src/utils/utils.dart';

class LoginPage extends StatelessWidget {

  final usuarioProvider = new UsuarioProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo( context ),
          _loginForm( context ),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric( vertical: 50.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                  Text('MercaTEc', style: TextStyle(fontSize: 25.0)),
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox( height: 60.0 ),
                _crearEmail( bloc ),
                SizedBox( height: 30.0 ),
                _crearPassword( bloc ),
                SizedBox( height: 30.0 ),
                _crearBoton( bloc )
              ],
            ),
          ),

          FlatButton(
            child: Text('Crear una nueva cuenta'),
            onPressed: ()=> Navigator.pushReplacementNamed(context, 'registro'),
          ),
          SizedBox( height: 100.0 )
        ],
      ),
    );


  }

  Widget _crearEmail(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),

        child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon( Icons.alternate_email, color: Colors.deepPurple ),
            hintText: 'ejemplo@correo.com',
            labelText: 'Correo electrónico',
            counterText: snapshot.data,
            errorText: snapshot.error
          ),
          onChanged: bloc.changeEmail,
        ),

      );


      },
    );


  }

  Widget _crearPassword(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),

          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline, color: Colors.deepPurple ),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),

        );

      },
    );


  }

  Widget _crearBoton( LoginBloc bloc) {

   

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? ()=> _login(bloc, context) : null
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {

    Map info = await usuarioProvider.login(bloc.email, bloc.password);

    if ( info['ok'] ) {
       Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta( context, info['mensaje'] );
    }
    
  }


  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );


    return Stack(
      children: <Widget>[
   
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
            // Icon( Icons.person_pin_circle, color: Colors.white, size: 100.0 ),
             Image(
          image:NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQroUj5xjuVM_vhu7fls1kakKCs51yHjAfMiFvAYyoosqlm3xfb&usqp=CAU')
           ),
              SizedBox( height: 10.0, width: double.infinity ),
             // Text('Informa App', style: TextStyle( color: Colors.blue, fontSize: 25.0 ))
            ],
          ),
        )

      ],
    );

  }

}