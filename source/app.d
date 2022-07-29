import std.math;
import scone;

const int SCR_W = 60;
const int SCR_H = 30;

const float theta_spacing = 0.07;
const float phi_spacing   = 0.02;

const float R1 = 1;
const float R2 = 2;
const float K2 = 5;

const float K1 = SCR_H*K2*3/(8*(R1+R2));


void donut(float A,float B)
{
    float cA = cos(A);
    float sA = sin(A);
    float cB = cos(B);
    float sB = sin(B);

    float[SCR_W][SCR_W] zbuffer = (cast(float) 0) ;

    for (float theta=0; theta < 2*PI; theta += theta_spacing) {
        float ct = cos(theta);
        float st = sin(theta);
        for (float phi = 0; phi < 2*PI; phi += phi_spacing) {
            float cp = cos(phi);
            float sp = sin(phi);

            float circle_x = R2 + R1*ct;
            float circle_y = R1*st;

            float x = circle_x*(cB*cp + sA*sB*sp) - circle_y*cA*sB;
            float y = circle_x*(sB*cp-sA*cB*sp) + circle_y*cA*cB;
            float z = K2 + cA*circle_x*sp + circle_y*sA;
            float ooz = 1/z;

            int xp = cast(int)(SCR_W/2 + K1*ooz*x);
            int yp = cast(int)(SCR_H/2 - K1*ooz*y);
            float L = cp*ct*sB - cA*ct*sp - sA*st + cB*(cA*st-ct*sA*sp);
            if (L>0) {
                if (ooz > zbuffer[xp][yp]) {
                    zbuffer[xp][yp] = ooz;
                    window.write(xp,yp,".,-~:;=!*#$@"[cast(int)(L*8)]);
                }
            }

        }
    }

}

void main()
{
    bool run = true;
    float A = 0;
    float B = 0;
    window.title("donut");
    window.resize(SCR_W + 10, SCR_H + 10);

    while(run)
    {
        foreach(input; window.getInputs())
        {
            //NOTE: Without a ^C handler you cannot quit the program (unless you taskmanager or SIGKILL it)

            //^C (Ctrl + C) or Escape
            if(input.key == SK.c)
            {
                run = false;
                break;
            }
        }
        window.clear();
        donut(A,B);
        window.print();
        A+=0.04;
        B+= 0.02;
    }
}
